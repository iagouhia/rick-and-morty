import Foundation

extension FavoriteEntity {
    func toDomain() -> FavoriteCharacter {
        FavoriteCharacter(
            id: Int(id),
            name: name ?? "Unknown",
            status: status,
            species: species,
            gender: gender,
            imageURL: imageUrl
        )
    }
}
