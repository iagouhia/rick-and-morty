import Foundation

final class GetCharacters {
    private let characterRepository: CharacterRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol

    init(
        characterRepository: CharacterRepositoryProtocol,
        favoritesRepository: FavoritesRepositoryProtocol
    ) {
        self.characterRepository = characterRepository
        self.favoritesRepository = favoritesRepository
    }

    func execute(page: Int) async throws -> CharacterPage {
        let pageResult = try await characterRepository.fetchCharacters(page: page)
        let favoriteIds = Set(await favoritesRepository.fetchFavorites().map { $0.id })

        let updatedCharacters = pageResult.characters.map { character in
            var updated = character
            updated.isFavorite = favoriteIds.contains(character.id)
            return updated
        }

        return CharacterPage(info: pageResult.info, characters: updatedCharacters)
    }
}
