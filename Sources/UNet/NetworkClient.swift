import Foundation

public class NetworkClient {
    private let transporter: NetworkTransporter
    private let endpointMapper: EndpointMapper
    public init(transporter: NetworkTransporter, endpointMapper: EndpointMapper) {
        self.transporter = transporter
        self.endpointMapper = endpointMapper
    }
    
    public func run<E: Endpoint>(endpoint: E) async throws -> E.Response {
        let request = try endpointMapper.makeRequest(for: endpoint)
        let (data, response) = try await transporter.dataTask(with: request)
        return try endpointMapper.readResponse(of: endpoint, from: data, response: response)
    }
}

public extension NetworkClient {
    convenience init(baseURL: URL, urlSession: URLSession = .shared) {
        let endpointMapper = SimpleEndpointMapper(baseURL: baseURL)
        self.init(transporter: urlSession, endpointMapper: endpointMapper)
    }
}
