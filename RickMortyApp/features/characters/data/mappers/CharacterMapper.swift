import Foundation

extension CharacterResponse {
    func toDomain() -> CharacterPage {
        CharacterPage(
            info: pageInfo.toDomain(),
            characters: results.map { $0.toDomain() }
        )
    }
}

extension PageInfo {
    func toDomain() -> PaginationInfo {
        PaginationInfo(count: count, pages: pages, next: next, prev: prev)
    }
}

extension CharacterInfo {
    func toDomain() -> Character {
        Character(
            id: id ?? 0,
            name: name ?? "Unknown",
            status: status?.toDomain(),
            species: species,
            gender: gender,
            imageURL: image,
            origin: origin?.toDomain(),
            location: location?.toDomain(),
            episodeURLs: episode ?? [],
            created: created,
            type: type,
            url: url,
            isFavorite: false
        )
    }
}

extension Status {
    func toDomain() -> CharacterStatus {
        switch self {
        case .alive:
            return .alive
        case .dead:
            return .dead
        case .unknown:
            return .unknown
        }
    }
}

extension Location {
    func toDomain() -> CharacterLocationInfo {
        CharacterLocationInfo(name: name ?? "Unknown", url: url)
    }
}

extension Origin {
    func toDomain() -> CharacterLocationInfo {
        CharacterLocationInfo(name: name ?? "Unknown", url: url)
    }
}
