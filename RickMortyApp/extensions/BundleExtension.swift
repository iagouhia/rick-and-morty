import Foundation

extension Bundle {
    /// Obtiene la versión de la app desde Info.plist
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    /// Obtiene el build number de la app desde Info.plist
    var appBuild: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}
