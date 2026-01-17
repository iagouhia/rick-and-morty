import Foundation

struct FavoriteCharacter: Identifiable, Hashable {
    let id: Int
    let name: String
    let status: String?
    let species: String?
    let gender: String?
    let imageURL: String?
}
