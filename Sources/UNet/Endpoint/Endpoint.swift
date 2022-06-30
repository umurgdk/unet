import Foundation

public protocol Endpoint {
    associatedtype Response: Decodable
    
    var path: String { get }
    var body: EndpointBody? { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem] { get }
}

public extension Endpoint {
    var body: EndpointBody? { nil }
    var method: HTTPMethod { .get }
    var parameters: [URLQueryItem] { [] }
}
