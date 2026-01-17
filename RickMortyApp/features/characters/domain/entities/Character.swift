import Foundation

struct Character: Identifiable, Hashable {
    let id: Int
    let name: String
    let status: CharacterStatus?
    let species: String?
    let gender: String?
    let imageURL: String?
    let origin: CharacterLocationInfo?
    let location: CharacterLocationInfo?
    let episodeURLs: [String]
    let created: String?
    let type: String?
    let url: String?
    var isFavorite: Bool

    static let placeholder = Character(
        id: 1,
        name: "Rick Sanchez",
        status: .alive,
        species: "Human",
        gender: "Male",
        imageURL: nil,
        origin: CharacterLocationInfo(name: "Earth (C-137)", url: nil),
        location: CharacterLocationInfo(name: "Citadel of Ricks", url: nil),
        episodeURLs: [],
        created: nil,
        type: nil,
        url: nil,
        isFavorite: false
    )
}
