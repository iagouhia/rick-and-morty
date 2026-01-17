import Foundation

/// Representa el estado de una vista o ViewModel
/// Utilidad genérica para manejar estados de carga, éxito y error en la capa de presentación
enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case error(AppError)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
    
    var data: T? {
        if case .success(let data) = self {
            return data
        }
        return nil
    }
    
    var error: AppError? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
}
