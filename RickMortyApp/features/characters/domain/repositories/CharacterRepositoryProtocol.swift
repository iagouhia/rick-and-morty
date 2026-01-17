import Foundation

protocol CharacterRepositoryProtocol {
    func fetchCharacters(page: Int) async throws -> CharacterPage
    func fetchCharacter(id: Int) async throws -> Character
}
