import Foundation

struct EpisodeResponse: Codable {
    let pageInfo: PageInfo?
    let results: [EpisodeInfo]?
}
