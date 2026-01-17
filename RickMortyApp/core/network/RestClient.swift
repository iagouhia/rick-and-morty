import Foundation

/// Provides access to the REST Backend
protocol RestClient {
    /// Retrieves a JSON resource and decodes it
    func get<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T

    /// Creates some resource by sending a JSON body and returning empty response
    func post<S: Encodable, E: Endpoint>(_ endpoint: E, using body: S) async throws
}

final class RestClientImpl: RestClient {
    private let session: URLSession

    init(sessionConfig: URLSessionConfiguration? = nil) {
        self.session = URLSession(configuration: sessionConfig ?? URLSessionConfiguration.default)
    }

    func get<T: Decodable, E: Endpoint>(_ endpoint: E) async throws -> T {
        let request = try buildRequest(endpoint: endpoint, method: "GET", jsonBody: Optional<String>.none)
        let response = try await startRequest(for: request)
        return try response.parseJson()
    }

    func post<S: Encodable, E: Endpoint>(_ endpoint: E, using body: S) async throws {
        let request = try buildRequest(endpoint: endpoint, method: "POST", jsonBody: body)
        _ = try await startRequest(for: request)
    }

    private func startRequest(for request: URLRequest) async throws -> InterimRestResponse {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RestClientErrors.noDataReceived
            }

            if httpResponse.statusCode == 400 {
                throw RestClientErrors.httpError(statusCode: httpResponse.statusCode)
            }

            return InterimRestResponse(data: data, response: httpResponse)
        } catch {
            throw RestClientErrors.networkFailure(error)
        }
    }

    private func buildRequest<T: Encodable, S: Endpoint>(
        endpoint: S,
        method: String,
        jsonBody: T?
    ) throws -> URLRequest {
        var request = URLRequest(url: endpoint.url, timeoutInterval: 10)
        request.httpMethod = method
        if let body = jsonBody {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw RestClientErrors.decodingFailure(error)
            }
        }
        return request
    }

    struct InterimRestResponse {
        let data: Data
        let response: HTTPURLResponse

        func parseJson<T: Decodable>() throws -> T {
            if data.isEmpty {
                throw RestClientErrors.noDataReceived
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw RestClientErrors.decodingFailure(error)
            }
        }
    }
}
