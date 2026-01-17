import Foundation

final class CharacterRepositoryImpl: CharacterRepositoryProtocol {
    private let remoteService: CharacterService

    init(remoteService: CharacterService) {
        self.remoteService = remoteService
    }

    func fetchCharacters(page: Int) async throws -> CharacterPage {
        let response = try await remoteService.getCharacters(page: page)
        return response.toDomain()
    }

    func fetchCharacter(id: Int) async throws -> Character {
        let response = try await remoteService.getCharacter(characterId: id)
        return response.toDomain()
    }
}
