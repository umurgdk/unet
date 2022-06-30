import Foundation

internal struct SimpleEndpoint<Response: Decodable>: Endpoint {
    let path: String
    let method: HTTPMethod
    let body: EndpointBody?
    let parameters: [URLQueryItem]
}

public extension NetworkClient {
    func get<R: Decodable>(_ type: R.Type = R.self, path: String, parameters: [String: String] = [:]) async throws -> R {
        try await run(
            endpoint: SimpleEndpoint<R>(
                path: path,
                method: .get,
                body: nil,
                parameters: makeQueryItems(from: parameters)
            )
        )
    }
    
    func post<R: Decodable, B: Encodable>(_ body: B, get response: R.Type = R.self, path: String, parameters: [String: String] = [:]) async throws -> R {
        try await run(
            endpoint: SimpleEndpoint<R>(
                path: path,
                method: .post,
                body: .value(of: body),
                parameters: makeQueryItems(from: parameters)
            )
        )
    }
    
    func put<R: Decodable, B: Encodable>(_ body: B, get response: R.Type = R.self, path: String, parameters: [String: String] = [:]) async throws -> R {
        try await run(
            endpoint: SimpleEndpoint<R>(
                path: path,
                method: .put,
                body: .value(of: body),
                parameters: makeQueryItems(from: parameters)
            )
        )
    }
    
    func delete<R: Decodable>(_ type: R.Type = R.self, path: String, parameters: [String: String] = [:]) async throws -> R {
        try await run(
            endpoint: SimpleEndpoint<R>(
                path: path,
                method: .delete,
                body: nil,
                parameters: makeQueryItems(from: parameters)
            )
        )
    }
    
    private func makeQueryItems(from parameters: [String: String]) -> [URLQueryItem] {
        parameters.reduce(into: []) { items, pair in
            items.append(URLQueryItem(name: pair.key, value: pair.value))
        }
    }
}
