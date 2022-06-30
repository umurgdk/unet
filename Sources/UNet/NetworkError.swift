import Foundation

public enum NetworkError: LocalizedError {
    case invalidURL
    case unsuccessfulResponse
    case serializationError(Error)
    case unexpectedResponse(Error?)
    case unreachable(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unsuccessfulResponse:
            return "Response status code indicates an error"
        case .serializationError(DecodingError.typeMismatch(let type, let ctx)):
            return "Serialization error: type mismatch: \(String(describing: type)), at: \(ctx.codingPath), \(ctx.debugDescription)"
        case .serializationError(let error):
            return "Serialization error: \(error.localizedDescription)"
        case .unexpectedResponse(let error):
            return "Unexpected response: \(error?.localizedDescription ?? "")"
        case .unreachable(let error):
            return "URL unreachable: \(error.localizedDescription)"
        }
    }
}
