import SwiftUI

struct FavoriteRow: View {
    var character: FavoriteCharacter
    
    var callback: (() -> Void)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Card)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
            
            HStack(spacing: 16) {
                if let image = character.imageURL,
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
                        }
                    }
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.Primary.opacity(0.2), lineWidth: 1)
                    )
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 90, height: 90)
                        .foregroundColor(.gray.opacity(0.2))
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(character.name)
                        .fontStyle(AppFont.body3)
                    
                    Text(character.species ?? "")
                        .fontStyle(AppFont.body)
                        .foregroundColor(.Text.opacity(0.7))
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(statusColor)
                            .frame(width: 10, height: 10)
                        
                        Text(character.status ?? "Unknown")
                            .fontStyle(AppFont.body5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { 
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        callback()
                    }
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.ToggleRed)
                        .font(.system(size: 20))
                        .padding(8)
                        .background(Color.ToggleRed.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(16)
        }
    }
    
    private var statusColor: Color {
        switch character.status?.lowercased() {
        case "alive":
            return Color.green
        case "dead":
            return Color.red
        default:
            return Color.gray
        }
    }
}

struct FavoriteRow_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteRow(
            character: FavoriteCharacter(
                id: 1,
                name: "Rick Sanchez",
                status: "Alive",
                species: "Human",
                gender: "Male",
                imageURL: nil
            ),
            callback: {
            
            }
        )
    }
}
