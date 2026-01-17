import Foundation

final class DeleteFavorite {
    private let repository: FavoritesRepositoryProtocol

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: Int) async {
        await repository.deleteFavorite(id: id)
    }
}
