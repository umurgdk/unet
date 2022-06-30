import Foundation

extension URLSession: NetworkTransporter {
    public func dataTask(with request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if #available(iOS 15, *) {
            let (data, urlResponse) = try await self.data(for: request)
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                throw NetworkError.unsuccessfulResponse
            }
            
            return (data, httpResponse)
        }
        
        return try await withCheckedThrowingContinuation { [self] continuation in
            dataTask(with: request) { data, response, error in
                if let error = error {
                    print("\(#function):\(#line) Network request failed: \(error.localizedDescription)")

                    continuation.resume(throwing: NetworkError.unreachable(error))
                    return
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: NetworkError.unexpectedResponse(nil))
                    return
                }
                
                continuation.resume(returning: (data, httpResponse))
            }.resume()
        }
    }
}
