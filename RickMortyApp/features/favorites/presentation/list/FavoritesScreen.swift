import SwiftUI

struct FavoritesScreen: View {
    private let container: AppContainer
    private let loadOnAppear: Bool
    @StateObject private var viewModel: FavoritesViewModel

    @MainActor init(
        container: AppContainer,
        viewModel: FavoritesViewModel? = nil,
        loadOnAppear: Bool = true
    ) {
        self.container = container
        self.loadOnAppear = loadOnAppear
        let resolvedViewModel = viewModel ?? container.makeFavoritesViewModel()
        _viewModel = StateObject(wrappedValue: resolvedViewModel)
    }
    
    @State
    private var bottomSheetShown: Bool = false

    @State
    private var selectedCharacter = FavoriteCharacter(
        id: 0,
        name: "",
        status: nil,
        species: nil,
        gender: nil,
        imageURL: nil
    )

    @State
    private var animateStar = false
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.favorites.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.favorites, id: \.id) { character in
                                NavigationLink(
                                    destination: DetailScreen(
                                        id: character.id,
                                        container: container
                                    ),
                                    label: {
                                        FavoriteRow(character: character, callback: {
                                            withAnimation {
                                                self.bottomSheetShown.toggle()
                                                self.selectedCharacter = character
                                            }
                                        })
                                    })
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .background(Color.Background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(LocalizedStringKey("toolbar_favorites_title")).fontStyle(AppFont.title)
                    }
                }
            }
            .onAppear(perform: {
                guard loadOnAppear else { return }
                _Concurrency.Task {
                    await viewModel.loadFavorites()
                }
            })
            .onChange(of: viewModel.favorites.isEmpty) {
                animateStar = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateStar = true
                }
            }

        }
        .bottomSheet(
            isPresented: $bottomSheetShown,
            height: 420,
            topBarHeight: 10,
            contentBackgroundColor: Color.Card,
            topBarBackgroundColor: Color.Card,
            showTopIndicator: true,
            content: {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Título
                        Text("Remove from Favorites")
                            .fontStyle(AppFont.heading)
                            .foregroundColor(.Text)
                        
                        // Nombre del personaje
                        Text(selectedCharacter.name)
                            .fontStyle(AppFont.body3)
                            .foregroundColor(.Primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                        // Descripción
                        Text("This character will be removed from your favorites list. This action cannot be undone.")
                            .fontStyle(AppFont.body)
                            .foregroundColor(.Text.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                            .padding(.horizontal, 8)
                        
                        // Botones
                        VStack(spacing: 12) {
                            Button(action: {
                                withAnimation {
                                    self.bottomSheetShown.toggle()
                                    _Concurrency.Task {
                                        await viewModel.deleteFavoriteItem(id: selectedCharacter.id)
                                    }
                                }
                            }) {
                                Text("Remove")
                                    .fontStyle(AppFont.body2)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.ToggleRed)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: { 
                                withAnimation {
                                    self.bottomSheetShown.toggle()
                                }
                            }) {
                                Text("Cancel")
                                    .fontStyle(AppFont.body2)
                                    .foregroundColor(.Text)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.Text.opacity(0.08))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
            })
    }

    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "star")
                .font(.system(size: 72))
                .foregroundColor(.Primary.opacity(animateStar ? 0.8 : 0.4))
                .scaleEffect(animateStar ? 1.1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: animateStar
                )

            VStack(spacing: 8) {
                Text(LocalizedStringKey("text_no_data_found"))
                    .fontStyle(AppFont.heading)
                    .foregroundColor(.Text)
                    .multilineTextAlignment(.center)

                Text("Agrega personajes a tus favoritos")
                    .fontStyle(AppFont.body)
                    .foregroundColor(.Text.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if !animateStar {
                animateStar = true
            }
        }
    }
    
    var sectionList : some View {
        List {
            ForEach(viewModel.favorites, id: \.id) { character in
                NavigationLink(
                    destination: DetailScreen(
                        id: character.id,
                        container: container
                    ),
                    label: {
                        FavoriteRow(character: character, callback: {
                            
                        })
                    }).swipeActions(edge: .trailing, content: {
                        Button (action: {  }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.ToggleRed)
                    })
                    .listRowInsets(.init(top: 0, leading: 8, bottom: 8, trailing: 8))
                    .listRowBackground(Color.Card)
                    .listRowSeparator(.visible, edges: .bottom)
                    .listRowSeparatorTint(.Background)
            }.onDelete(perform: {_ in })
        }
        .listStyle(.plain)
        .padding(.all, 8)
        .background(Color.Background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(LocalizedStringKey("toolbar_favorites_title")).fontStyle(AppFont.title)
                }
            }
        }.onAppear(perform: {
            guard loadOnAppear else { return }
            _Concurrency.Task {
                await viewModel.loadFavorites()
            }
        })
    }
    
    func delete(at source: IndexSet) {
        
    }
}

struct FavoritesScreen_Previews: PreviewProvider {
    @MainActor static var previews: some View {
        let container = AppContainer.preview()

        let emptyViewModel = container.makeFavoritesViewModel()
        emptyViewModel.favorites = []

        let dataViewModel = container.makeFavoritesViewModel()
        dataViewModel.favorites = PreviewData.favorites

        return Group {
            FavoritesScreen(
                container: container,
                viewModel: emptyViewModel,
                loadOnAppear: false
            )
            .previewDisplayName("Empty")
            .colorScheme(.dark)

            FavoritesScreen(
                container: container,
                viewModel: dataViewModel,
                loadOnAppear: false
            )
            .previewDisplayName("Data")
            .colorScheme(.dark)
        }
        .background(Color.Background)
        .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
}
