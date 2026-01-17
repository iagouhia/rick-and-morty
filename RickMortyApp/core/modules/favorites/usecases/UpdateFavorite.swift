import Foundation

final class UpdateFavorite {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(character: FavoriteCharacter) async {
        let existing = await repository.fetchFavorite(id: character.id)
        if existing == nil {
            await repository.saveFavorite(character)
        } else {
            await repository.deleteFavorite(id: character.id)
        }
    }
}
