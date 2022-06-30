import Foundation

public protocol EndpointMapper {
    func makeRequest<T: Endpoint>(for endpoint: T) throws -> URLRequest
    func readResponse<T: Endpoint>(of endpoint: T, from data: Data, response: HTTPURLResponse) throws -> T.Response
}

public extension EndpointMapper where Self == SimpleEndpointMapper {
    static func simple(
        baseURL: URL,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) -> Self {
        return SimpleEndpointMapper(baseURL: baseURL, encoder: encoder, decoder: decoder)
    }
}

public struct SimpleEndpointMapper: EndpointMapper {
    public let baseURL: URL
    public let encoder: JSONEncoder
    public let decoder: JSONDecoder
    
    public init(
        baseURL: URL,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public func makeRequest<T: Endpoint>(for endpoint: T) throws -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.path += endpoint.path
        
        if !endpoint.parameters.isEmpty {
            urlComponents?.queryItems = endpoint.parameters
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        switch endpoint.body {
        case .raw(let data):
            request.httpBody = data
        case .value(let encodable):
            request.httpBody = try encoder.encode(encodable)
        case .none:
            break
        }
        
        return request
    }
    
    public func readResponse<T: Endpoint>(of endpoint: T, from data: Data, response: HTTPURLResponse) throws -> T.Response {
        guard (200..<400).contains(response.statusCode) else {
            throw NetworkError.unsuccessfulResponse
        }
        
        do {
            return try decoder.decode(T.Response.self, from: data)
        } catch {
            throw NetworkError.serializationError(error)
        }
    }
}
