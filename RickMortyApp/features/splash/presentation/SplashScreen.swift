import SwiftUI

struct SplashScreen: View {
    private let container: AppContainer
    @State var isActive:Bool = false

    init(container: AppContainer) {
        self.container = container
    }
    
    var body: some View {
        if self.isActive {
            HomeScreen(container: container)
        } else {
            VStack(alignment: HorizontalAlignment.center, spacing: 20) {
                Image(uiImage: UIImage(named: "ic_splash.jpeg")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 200)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .background(Color("blue_primary"))
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            })
        }
    }
}

#if DEBUG
struct SplashScreen_Previews: PreviewProvider {
    @MainActor static var previews: some View {
        SplashScreen(container: AppContainer.preview())
    }
}
#endif
