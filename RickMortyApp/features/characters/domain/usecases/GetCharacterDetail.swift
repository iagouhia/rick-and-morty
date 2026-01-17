import Foundation

final class GetCharacterDetail {
    private let characterRepository: CharacterRepositoryProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol

    init(
        characterRepository: CharacterRepositoryProtocol,
        favoritesRepository: FavoritesRepositoryProtocol
    ) {
        self.characterRepository = characterRepository
        self.favoritesRepository = favoritesRepository
    }

    func execute(characterId: Int) async throws -> Character {
        var character = try await characterRepository.fetchCharacter(id: characterId)
        let favorite = await favoritesRepository.fetchFavorite(id: characterId)
        character.isFavorite = favorite != nil
        return character
    }
}
