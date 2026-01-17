import Foundation

protocol CharacterService {
    func getCharacters(page: Int) async throws -> CharacterResponse
    func getCharacter(characterId: Int) async throws -> CharacterInfo
}

final class CharacterServiceImpl: CharacterService {
    private let restClient: RestClient

    init(restClient: RestClient) {
        self.restClient = restClient
    }

    func getCharacters(page: Int) async throws -> CharacterResponse {
        try await restClient.get(APIEndpoint.characters(page))
    }

    func getCharacter(characterId: Int) async throws -> CharacterInfo {
        try await restClient.get(APIEndpoint.character(characterId))
    }
}
