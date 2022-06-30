import Foundation

public protocol NetworkTransporter {
    func dataTask(with request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

