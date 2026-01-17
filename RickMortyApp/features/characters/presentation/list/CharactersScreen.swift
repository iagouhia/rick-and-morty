import SwiftUI

struct CharactersScreen: View {
    private let container: AppContainer
    private let loadOnAppear: Bool
    @StateObject private var viewModel: CharactersViewModel

    @MainActor init(
        container: AppContainer,
        viewModel: CharactersViewModel? = nil,
        loadOnAppear: Bool = true
    ) {
        self.container = container
        self.loadOnAppear = loadOnAppear
        let resolvedViewModel = viewModel ?? container.makeCharactersViewModel()
        _viewModel = StateObject(wrappedValue: resolvedViewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.Background.edgesIgnoringSafeArea(.all)
                contentView
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(LocalizedStringKey("toolbar_characters_title"))
                            .fontStyle(AppFont.title)
                    }
                }
            }
            .onAppear {
                guard loadOnAppear else { return }
                _Concurrency.Task {
                    if viewModel.charactersList.isEmpty {
                        await viewModel.loadPage()
                    } else {
                        // Actualizar estado de favoritos cuando vuelve a la pantalla
                        await viewModel.refreshFavoritesStatus()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .idle, .loading:
            if viewModel.charactersList.isEmpty {
                loadingView
            } else {
                charactersListView
            }
            
        case .success:
            if viewModel.charactersList.isEmpty {
                emptyStateView
            } else {
                charactersListView
            }
            
        case .error:
            if viewModel.charactersList.isEmpty {
                errorView
            } else {
                charactersListView
                    .overlay(
                        VStack {
                            Spacer()
                            errorBanner
                        }
                    )
            }
        }
    }
    
    private var charactersListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.charactersList, id: \.id) { character in
                    NavigationLink(
                        destination: DetailScreen(
                            id: character.id,
                            container: container
                        ),
                        label: {
                            CharacterRow(character: character) { favorState in
                                Log.debug("Favorite state: \(favorState)")
                                _Concurrency.Task {
                                    await viewModel.updateFavor(character: character, state: favorState)
                                }
                            }
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                if viewModel.hasMorePages {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .Primary))
                        .scaleEffect(1.2)
                        .padding(.vertical, 20)
                        .onAppear {
                            _Concurrency.Task {
                                await viewModel.loadNextPage()
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .Primary))
                .scaleEffect(1.8)
            
            Text("Cargando personajes...")
                .fontStyle(AppFont.heading)
                .foregroundColor(.Text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 72))
                .foregroundColor(.Primary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No hay personajes disponibles")
                    .fontStyle(AppFont.heading)
                    .foregroundColor(.Text)
                    .multilineTextAlignment(.center)
                
                Text("Intenta recargar la página")
                    .fontStyle(AppFont.body)
                    .foregroundColor(.Text.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red.opacity(0.7))
            
            Text(viewModel.errorMessage ?? "Error desconocido")
                .fontStyle(AppFont.heading)
                .foregroundColor(.Text)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let recovery = viewModel.state.error?.recoverySuggestion {
                Text(recovery)
                    .fontStyle(AppFont.body)
                    .foregroundColor(.Text.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: {
                _Concurrency.Task {
                    await viewModel.retry()
                }
            }) {
                Text("Reintentar")
                    .fontStyle(AppFont.body2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Color.red)
                    .cornerRadius(12)
                    .shadow(color: Color.Primary.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding()
    }
    
    private var errorBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 18))
            
            Text(viewModel.errorMessage ?? "Error al cargar más personajes")
                .fontStyle(AppFont.body)
                .foregroundColor(.Text)
            
            Spacer()
            
            Button("Reintentar") {
                _Concurrency.Task {
                    await viewModel.retry()
                }
            }
            .fontStyle(AppFont.body2)
            .foregroundColor(.Primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.Primary.opacity(0.1))
            .cornerRadius(8)
        }
        .padding(16)
        .background(Color.Card)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

struct CharactersScreen_Previews: PreviewProvider {
    @MainActor static var previews: some View {
        let container = AppContainer.preview()

        let loadingViewModel = container.makeCharactersViewModel()
        loadingViewModel.state = .loading
        loadingViewModel.charactersList = []

        let errorViewModel = container.makeCharactersViewModel()
        errorViewModel.state = .error(.networkError("Sin conexion"))
        errorViewModel.charactersList = []

        let dataViewModel = container.makeCharactersViewModel()
        dataViewModel.state = .success(PreviewData.characters)
        dataViewModel.charactersList = PreviewData.characters
        dataViewModel.hasMorePages = true

        return Group {
            CharactersScreen(
                container: container,
                viewModel: loadingViewModel,
                loadOnAppear: false
            )
            .previewDisplayName("Loading")

            CharactersScreen(
                container: container,
                viewModel: errorViewModel,
                loadOnAppear: false
            )
            .previewDisplayName("Error")

            CharactersScreen(
                container: container,
                viewModel: dataViewModel,
                loadOnAppear: false
            )
            .previewDisplayName("Data")
        }
    }
}
