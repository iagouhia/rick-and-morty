import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    private let getFavorites: GetFavorites
    private let deleteFavorite: DeleteFavorite

    @Published var favorites = [FavoriteCharacter]()

    init(
        getFavorites: GetFavorites,
        deleteFavorite: DeleteFavorite
    ) {
        self.getFavorites = getFavorites
        self.deleteFavorite = deleteFavorite
    }

    func loadFavorites() async {
        favorites = await getFavorites.execute()
    }

    func deleteFavoriteItem(id: Int) async {
        await deleteFavorite.execute(id: id)
        await loadFavorites()
    }
}
