
import Foundation

public struct Curl: CustomStringConvertible {

    public var bash: String
    public var description: String { bash }

    public init(
        url: String,
        method: String = "GET",
        parameters: [String: Any] = [:],
        headers: [String: String] = [:],
        arguments: [String] = ["-s"]
    ) throws {
        let headerBuilder = { (key: String, value: String) in "--header '\(key): \(value)'" }
        let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let jsonString = String(data: data, encoding: .utf8)!
        let defaultHeaders = [
            "Content-Type": "application/json"
        ]
        let app = "curl"
        let jsonBody = "--data '\(jsonString)'"
        let urlString = "--url \(url)"
        let headersDirectives = defaultHeaders.map(headerBuilder) + headers.map(headerBuilder)
        let method = "--request \(method)"

        bash = (
            [app]
                + arguments
                + [method, urlString]
                + headersDirectives
                + [jsonBody]
        ).joined(separator: " ")
    }
}

#if os(macOS) || os(Linux)
import Shell

extension Curl {

    public func sync() -> Data { shell(bash) }
}

import PromiseKit

extension Curl {

    private static let queue = DispatchQueue(label: "curl", attributes: .concurrent)

    public func async() -> Promise<Data> {
        Promise<Data> { resolver in
            Curl.queue.async {
                resolver.resolve(.fulfilled(sync()))
            }
        }
    }
}
#endif
