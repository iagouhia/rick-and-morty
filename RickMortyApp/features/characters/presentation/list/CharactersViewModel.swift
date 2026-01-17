
import Foundation

@MainActor
final class CharactersViewModel: ObservableObject {
    private let getCharacters: GetCharacters
    private let updateFavorite: UpdateFavorite
    private let getFavorites: GetFavorites
    
    // Estado principal de la lista de personajes
    @Published var state: ViewState<[Character]> = .idle
    @Published var charactersList: [Character] = []
    
    // Estado de paginación
    private var page = 1
    private var totalPages = 0
    @Published var hasMorePages = false
    @Published var isLoadingMore = false
    
    init(
        getCharacters: GetCharacters,
        updateFavorite: UpdateFavorite,
        getFavorites: GetFavorites
    ) {
        self.getCharacters = getCharacters
        self.updateFavorite = updateFavorite
        self.getFavorites = getFavorites
    }
    
    var isLoading: Bool {
        state.isLoading && charactersList.isEmpty
    }
    
    var hasError: Bool {
        state.isError
    }
    
    var errorMessage: String? {
        state.error?.errorDescription
    }
    
    private func resetPaging() {
        self.page = 1
        self.totalPages = 0
        self.charactersList.removeAll()
    }
    
    /// Carga la primera página de personajes
    func loadPage() async {
        guard !state.isLoading else { return }
        
        resetPaging()
        state = .loading

        do {
            let response = try await getCharacters.execute(page: page)
            totalPages = response.info.pages
            page += 1
            charactersList = response.characters
            hasMorePages = page <= totalPages
            state = .success(charactersList)
        } catch {
            state = .error(AppError.from(error))
        }
    }
    
    /// Carga la siguiente página de personajes
    func loadNextPage() async {
        guard page <= totalPages && !isLoadingMore && !state.isLoading else {
            return
        }
        
        isLoadingMore = true

        do {
            let response = try await getCharacters.execute(page: page)
            totalPages = response.info.pages
            page += 1
            charactersList.append(contentsOf: response.characters)
            hasMorePages = page <= totalPages
        } catch {
            Log.error("Error loading next page: \(error.localizedDescription)")
        }

        isLoadingMore = false
    }
    
    /// Actualiza el estado de favorito de un personaje
    func updateFavor(character: Character, state: Bool) async {
        await updateFavorite.execute(character: character.toFavoriteCharacter())

        if let index = charactersList.firstIndex(where: { $0.id == character.id }) {
            charactersList[index].isFavorite = state
        }
    }
    
    /// Reintenta cargar los datos después de un error
    func retry() async {
        await loadPage()
    }
    
    /// Actualiza el estado de favoritos de los personajes en la lista
    func refreshFavoritesStatus() async {
        let favoriteIds = Set(await getFavorites.execute().map { $0.id })

        for index in charactersList.indices {
            charactersList[index].isFavorite = favoriteIds.contains(charactersList[index].id)
        }
    }
}
