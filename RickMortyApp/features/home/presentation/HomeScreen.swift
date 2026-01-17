import SwiftUI

struct HomeScreen: View {
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.Card)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
        
        // Colors for selected items
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.UnSelectedBottomItem)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.UnSelectedBottomItem)
        ]
        
        // Colors for unselected items
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.Primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.Primary)
        ]
        
        // Use this appearance when scrolling behind the TabView:
        UITabBar.appearance().standardAppearance = appearance
        // Use this appearance when scrolled all the way up:
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().barTintColor = UIColor(Color.Card)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.UnSelectedBottomItem)
        UITabBar.appearance().tintColor = UIColor(Color.Primary)
    }
    
    var body: some View {
        TabView {
            CharactersScreen(container: container).tabItem {
                Label(LocalizedStringKey("bottom_menu_characters"), systemImage: "person.3.fill").fontStyle(AppFont.body5)
            }
            FavoritesScreen(container: container)
                .tabItem {
                Label(LocalizedStringKey("bottom_menu_favorites"), systemImage: "star.fill").fontStyle(AppFont.body5)
            }
            SettingsScreen().tabItem {
                Label(LocalizedStringKey("bottom_menu_settings"), systemImage: "gearshape.fill").fontStyle(AppFont.body5)
            }
        }
        .accentColor(Color.SelectedBottomItem)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    @MainActor static var previews: some View {
        HomeScreen(container: AppContainer.preview())
    }
}
