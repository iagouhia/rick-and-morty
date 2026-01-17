import Foundation

extension Character {
    func toFavoriteCharacter() -> FavoriteCharacter {
        FavoriteCharacter(
            id: id,
            name: name,
            status: status?.displayName,
            species: species,
            gender: gender,
            imageURL: imageURL
        )
    }
}
