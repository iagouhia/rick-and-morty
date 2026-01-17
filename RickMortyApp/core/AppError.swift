
import Foundation

enum AppError: LocalizedError, Equatable {
    case networkError(String)
    case serverError(Int)
    case decodingError
    case unknownError
    case noData
    case invalidRequest
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Error de conexión: \(message)"
        case .serverError(let code):
            return "Error del servidor (código: \(code))"
        case .decodingError:
            return "Error al procesar los datos"
        case .unknownError:
            return "Ha ocurrido un error inesperado"
        case .noData:
            return "No se recibieron datos"
        case .invalidRequest:
            return "Solicitud inválida"
        case .timeout:
            return "La solicitud tardó demasiado. Intenta de nuevo"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError, .timeout:
            return "Verifica tu conexión a internet e intenta de nuevo"
        case .serverError:
            return "El servidor está experimentando problemas. Intenta más tarde"
        case .decodingError, .noData:
            return "Los datos recibidos no son válidos"
        case .unknownError, .invalidRequest:
            return "Por favor, intenta de nuevo más tarde"
        }
    }
    
    static func from(_ error: Error) -> AppError {
        // Si el error ya sabe cómo convertirse, delegar
        if let restError = error as? RestClientErrors {
            return restError.toAppError()
        }
        
        // Fallback para errores no contemplados
        return .unknownError
    }
}
