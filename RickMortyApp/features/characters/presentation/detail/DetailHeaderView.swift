import Foundation
import SwiftUI

struct DetailHeaderView: View {
    var character: Character? = nil
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            if let image = character?.imageURL,
               let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .Primary))
                            .scaleEffect(1.5)
                    }
                }
                .frame(width: 240, height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            borderColor,
                            lineWidth: 5
                        )
                )
                .shadow(color: Color.Primary.opacity(0.2), radius: 12, x: 0, y: 6)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .transition(.scale.combined(with: .opacity))
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 240, height: 240)
                    .foregroundColor(.gray.opacity(0.2))
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .Primary))
                            .scaleEffect(1.5)
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    private var borderColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
}

struct DetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DetailHeaderView()
    }
}
