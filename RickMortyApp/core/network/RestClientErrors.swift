import Foundation

enum RestClientErrors: Error {
    case networkFailure(Error)
    case httpError(statusCode: Int)
    case noDataReceived
    case decodingFailure(Error)
}

extension RestClientErrors {
    func toAppError() -> AppError {
        switch self {
        case .networkFailure(let error):
            return Self.handleNetworkError(error)

        case .httpError(let statusCode):
            return .serverError(statusCode)
            
        case .noDataReceived:
            return .noData
            
        case .decodingFailure(let error):
            if error is URLError {
                return Self.handleNetworkError(error)
            }
            return .decodingError
        }
    }
    
    private static func handleNetworkError(_ error: Error) -> AppError {
        guard let urlError = error as? URLError else {
            return .networkError(error.localizedDescription)
        }
        
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .networkError("Sin conexión a internet")
        case .timedOut:
            return .timeout
        default:
            return .networkError(urlError.localizedDescription)
        }
    }
}
