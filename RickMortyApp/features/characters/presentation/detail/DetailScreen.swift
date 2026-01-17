import SwiftUI

struct DetailScreen: View {
    private let container: AppContainer
    private let loadOnAppear: Bool
    @StateObject private var viewModel: DetailViewModel
    @State
    private var characterId: Int = 0
    
    @MainActor init(
        id: Int,
        container: AppContainer,
        viewModel: DetailViewModel? = nil,
        loadOnAppear: Bool = true
    ) {
        self.container = container
        self.loadOnAppear = loadOnAppear
        let resolvedViewModel = viewModel ?? container.makeDetailViewModel()
        _viewModel = StateObject(wrappedValue: resolvedViewModel)
        _characterId = State(initialValue: id)
    }
    
    var body: some View {
        ZStack {
            Color.Background.edgesIgnoringSafeArea(.all)
            ScrollView {
                LazyVStack(spacing: 20) {
                    DetailHeaderView(character: viewModel.character)
                    DetailContentView(contents: viewModel.details, character: viewModel.character)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey("toolbar_detail_title")).fontStyle(AppFont.title)
                }
            }
        }
        .onAppear(perform: {
            guard loadOnAppear else { return }
            _Concurrency.Task {
                await viewModel.loadDetail(characterId: characterId)
            }
        })
    }
}

struct DetailScreen_Previews: PreviewProvider {
    @MainActor static var previews: some View {
        let container = AppContainer.preview()
        let loadingViewModel = container.makeDetailViewModel()

        let dataViewModel = container.makeDetailViewModel()
        if let character = PreviewData.characters.first {
            dataViewModel.character = character
            dataViewModel.details = dataViewModel.getDetails(character: character)
        }

        return Group {
            DetailScreen(
                id: 1,
                container: container,
                viewModel: loadingViewModel,
                loadOnAppear: false
            )
            .previewDisplayName("Loading")

            DetailScreen(
                id: 1,
                container: container,
                viewModel: dataViewModel,
                loadOnAppear: false
            )
            .previewDisplayName("Data")
        }
    }
}
