import Foundation

protocol FavoritesRepositoryProtocol {
    func fetchFavorites() async -> [FavoriteCharacter]
    func fetchFavorite(id: Int) async -> FavoriteCharacter?
    func saveFavorite(_ character: FavoriteCharacter) async
    func deleteFavorite(id: Int) async
}
