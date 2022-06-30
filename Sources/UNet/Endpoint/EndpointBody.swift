import Foundation

public enum EndpointBody {
    case raw(Data)
    case value(AnyEncodable)
    
    public struct AnyEncodable: Encodable {
        let encode: (Encoder) throws -> Void
    }
    
    public static func value<T: Encodable>(of value: T) -> Self {
        .value(AnyEncodable(value))
    }
}

public extension EndpointBody.AnyEncodable {
    init<T: Encodable>(_ value: T) {
        self.encode = { try value.encode(to: $0) }
    }
    
    func encode(to encoder: Encoder) throws {
        try self.encode(encoder)
    }
}
