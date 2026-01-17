import Foundation
import UIKit

enum PreviewData {
    private static func bundleImageURL(named name: String) -> String? {
        let image = UIImage(named: name, in: Bundle.main, compatibleWith: nil)
            ?? UIImage(named: name, in: Bundle(for: PreviewCharacterRepository.self), compatibleWith: nil)
        
        guard let image = image,
              let imageData = image.pngData() else {
            return nil
        }
        let base64String = imageData.base64EncodedString()
        return "data:image/png;base64,\(base64String)"
    }
    
    static let characters: [Character] = [
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            gender: "Male",
            imageURL: bundleImageURL(named: "preview_rick"),
            origin: CharacterLocationInfo(name: "Earth (C-137)", url: nil),
            location: CharacterLocationInfo(name: "Citadel of Ricks", url: nil),
            episodeURLs: ["https://example.com/episode/1"],
            created: "2017-11-04T18:48:46.250Z",
            type: nil,
            url: nil,
            isFavorite: false
        ),
        Character(
            id: 2,
            name: "Morty Smith",
            status: .alive,
            species: "Human",
            gender: "Male",
            imageURL: bundleImageURL(named: "preview_morty"),
            origin: CharacterLocationInfo(name: "Earth (C-137)", url: nil),
            location: CharacterLocationInfo(name: "Earth (Replacement Dimension)", url: nil),
            episodeURLs: ["https://example.com/episode/2"],
            created: "2017-11-04T18:50:21.651Z",
            type: nil,
            url: nil,
            isFavorite: false
        ),
        Character(
            id: 3,
            name: "Summer Smith",
            status: .alive,
            species: "Human",
            gender: "Female",
            imageURL: bundleImageURL(named: "preview_summer"),
            origin: CharacterLocationInfo(name: "Earth (C-137)", url: nil),
            location: CharacterLocationInfo(name: "Earth (Replacement Dimension)", url: nil),
            episodeURLs: ["https://example.com/episode/3"],
            created: "2017-11-04T19:09:56.428Z",
            type: nil,
            url: nil,
            isFavorite: false
        )
    ]

    static let favorites: [FavoriteCharacter] = [
        FavoriteCharacter(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            gender: "Male",
            imageURL: bundleImageURL(named: "preview_rick")
        )
    ]
}

final class PreviewCharacterRepository: CharacterRepositoryProtocol {
    private let characters: [Character]

    init(characters: [Character]) {
        self.characters = characters
    }

    func fetchCharacters(page: Int) async throws -> CharacterPage {
        let info = PaginationInfo(
            count: characters.count,
            pages: 1,
            next: nil,
            prev: nil
        )
        return CharacterPage(info: info, characters: characters)
    }

    func fetchCharacter(id: Int) async throws -> Character {
        if let character = characters.first(where: { $0.id == id }) {
            return character
        }
        throw AppError.noData
    }
}

final class PreviewFavoritesRepository: FavoritesRepositoryProtocol {
    private var favorites: [FavoriteCharacter]

    init(favorites: [FavoriteCharacter]) {
        self.favorites = favorites
    }

    func fetchFavorites() async -> [FavoriteCharacter] {
        favorites
    }

    func fetchFavorite(id: Int) async -> FavoriteCharacter? {
        favorites.first(where: { $0.id == id })
    }

    func saveFavorite(_ character: FavoriteCharacter) async {
        guard !favorites.contains(where: { $0.id == character.id }) else { return }
        favorites.append(character)
    }

    func deleteFavorite(id: Int) async {
        favorites.removeAll { $0.id == id }
    }
}
