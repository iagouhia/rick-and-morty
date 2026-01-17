import Foundation

final class GetFavorites {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> [FavoriteCharacter] {
        await repository.fetchFavorites()
    }
}
