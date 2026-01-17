import Foundation

final class AppContainer {
    private let getCharacters: GetCharacters
    private let getCharacterDetail: GetCharacterDetail
    private let getFavorites: GetFavorites
    private let updateFavorite: UpdateFavorite
    private let deleteFavorite: DeleteFavorite

    init(
        getCharacters: GetCharacters,
        getCharacterDetail: GetCharacterDetail,
        getFavorites: GetFavorites,
        updateFavorite: UpdateFavorite,
        deleteFavorite: DeleteFavorite
    ) {
        self.getCharacters = getCharacters
        self.getCharacterDetail = getCharacterDetail
        self.getFavorites = getFavorites
        self.updateFavorite = updateFavorite
        self.deleteFavorite = deleteFavorite
    }

    static func live() -> AppContainer {
        let restClient = RestClientImpl()
        let coreDataManager = CoreDataManager()
        let characterService = CharacterServiceImpl(restClient: restClient)
        let characterRepository = CharacterRepositoryImpl(remoteService: characterService)
        let favoritesRepository = FavoritesRepositoryImpl(coreDataManager: coreDataManager)

        return AppContainer(
            getCharacters: GetCharacters(
                characterRepository: characterRepository,
                favoritesRepository: favoritesRepository
            ),
            getCharacterDetail: GetCharacterDetail(
                characterRepository: characterRepository,
                favoritesRepository: favoritesRepository
            ),
            getFavorites: GetFavorites(repository: favoritesRepository),
            updateFavorite: UpdateFavorite(repository: favoritesRepository),
            deleteFavorite: DeleteFavorite(repository: favoritesRepository)
        )
    }

    static func preview(
        characters: [Character] = PreviewData.characters,
        favorites: [FavoriteCharacter] = PreviewData.favorites
    ) -> AppContainer {
        let characterRepository = PreviewCharacterRepository(characters: characters)
        let favoritesRepository = PreviewFavoritesRepository(favorites: favorites)

        return AppContainer(
            getCharacters: GetCharacters(
                characterRepository: characterRepository,
                favoritesRepository: favoritesRepository
            ),
            getCharacterDetail: GetCharacterDetail(
                characterRepository: characterRepository,
                favoritesRepository: favoritesRepository
            ),
            getFavorites: GetFavorites(repository: favoritesRepository),
            updateFavorite: UpdateFavorite(repository: favoritesRepository),
            deleteFavorite: DeleteFavorite(repository: favoritesRepository)
        )
    }

    @MainActor
    func makeCharactersViewModel() -> CharactersViewModel {
        CharactersViewModel(
            getCharacters: getCharacters,
            updateFavorite: updateFavorite,
            getFavorites: getFavorites
        )
    }

    @MainActor
    func makeDetailViewModel() -> DetailViewModel {
        DetailViewModel(getCharacterDetail: getCharacterDetail)
    }

    @MainActor
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(
            getFavorites: getFavorites,
            deleteFavorite: deleteFavorite
        )
    }
}
