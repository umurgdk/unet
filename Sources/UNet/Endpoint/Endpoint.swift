import Foundation

public protocol Endpoint {
    associatedtype Response: Decodable
    
    var path: String { get }
    var body: EndpointBody? { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem] { get }
}

public extension Endpoint {
    var body: EndpointBody? { nil }
    var headers: [String: String] { [:] }
    var method: HTTPMethod { .get }
    var parameters: [URLQueryItem] { [] }
}
