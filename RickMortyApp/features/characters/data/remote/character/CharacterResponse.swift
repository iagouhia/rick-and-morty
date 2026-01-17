import Foundation

struct CharacterResponse: Codable {
    let pageInfo: PageInfo
    let results: [CharacterInfo]
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results = "results"
    }
}
