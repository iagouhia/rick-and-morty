import Foundation

enum CharacterStatus: String, Hashable {
    case alive
    case dead
    case unknown

    var displayName: String {
        switch self {
        case .alive:
            return "Alive"
        case .dead:
            return "Dead"
        case .unknown:
            return "Unknown"
        }
    }
}
