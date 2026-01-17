import Foundation

final class FavoritesRepositoryImpl: FavoritesRepositoryProtocol {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func fetchFavorites() async -> [FavoriteCharacter] {
        coreDataManager.getFavoriteList().map { $0.toDomain() }
    }

    func fetchFavorite(id: Int) async -> FavoriteCharacter? {
        coreDataManager.getFavorite(id: id)?.toDomain()
    }

    func saveFavorite(_ character: FavoriteCharacter) async {
        coreDataManager.saveFavorite(
            id: character.id,
            status: character.status,
            gender: character.gender,
            name: character.name,
            imageUrl: character.imageURL,
            species: character.species
        )
    }

    func deleteFavorite(id: Int) async {
        coreDataManager.deleteFavorite(id: id)
    }
}
