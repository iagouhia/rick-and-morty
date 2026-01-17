import SwiftUI
import UIKit

@main
struct RickMortyApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    private let container = AppContainer.live()
    
    init() {
        configureNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen(container: container)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environment(\.locale, .init(identifier: "en"))
        }
    }
    
    private func configureNavigationBarAppearance() {
        let standard = UINavigationBarAppearance()
        standard.configureWithOpaqueBackground()
        standard.backgroundColor = UIColor(Color.Background)
        standard.titleTextAttributes = [.foregroundColor: UIColor(Color.Text)]
        standard.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.Text)]
        
        let compact = UINavigationBarAppearance()
        compact.configureWithOpaqueBackground()
        compact.backgroundColor = UIColor(Color.Background)
        compact.titleTextAttributes = [.foregroundColor: UIColor(Color.Text)]
        
        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.configureWithOpaqueBackground()
        scrollEdge.backgroundColor = UIColor(Color.Background)
        scrollEdge.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.Text)]
        
        UINavigationBar.appearance().standardAppearance = standard
        UINavigationBar.appearance().compactAppearance = compact
        UINavigationBar.appearance().scrollEdgeAppearance = scrollEdge
        UINavigationBar.appearance().tintColor = UIColor(Color.Primary)
    }
}
