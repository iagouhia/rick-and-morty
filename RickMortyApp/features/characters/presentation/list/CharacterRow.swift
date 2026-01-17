import SwiftUI
import Foundation

struct CharacterRow: View {
    var character: Character
    var callback: ((_ favorState: Bool) -> Void)?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Card)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
            
            HStack(alignment: .top, spacing: 12) {
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
                    .frame(width: 80)
                    .frame(maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.Primary.opacity(0.2), lineWidth: 1)
                    )
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                        .foregroundColor(.gray.opacity(0.2))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // Nombre con padding derecho para evitar solaparse con el badge del estado
                    Text(character.name)
                        .fontStyle(AppFont.body3)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.trailing, 90) // Espacio para el badge del estado
                    
                    // Especie con icono
                    HStack(spacing: 6) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12))
                            .foregroundColor(.Primary.opacity(0.7))
                        Text(character.species ?? "")
                            .fontStyle(AppFont.body)
                            .foregroundColor(.Text.opacity(0.7))
                            .lineLimit(1)
                    }
                    
                    // Género y favorito en la misma fila
                    HStack(spacing: 8) {
                        if let gender = character.gender, !gender.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: genderIcon(gender))
                                    .font(.system(size: 12))
                                    .foregroundColor(.Primary.opacity(0.7))
                                Text(gender)
                                    .fontStyle(AppFont.body5)
                                    .foregroundColor(.Text.opacity(0.6))
                            }
                        } else {
                            // Si no hay género, mostrar solo el espacio para mantener alineación
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // Botón de favorito
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                let updatedState = !character.isFavorite
                                callback?(updatedState)
                            }
                        }) {
                            Image(systemName: character.isFavorite ? "star.fill" : "star")
                                .foregroundColor(character.isFavorite ? .Primary : Color.gray.opacity(0.5))
                                .font(.system(size: 20))
                                .scaleEffect(character.isFavorite ? 1.1 : 1.0)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            
            // Estado arriba a la derecha
            if let status = character.status {
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 10, height: 10)
                        .shadow(color: statusColor.opacity(0.5), radius: 2, x: 0, y: 0)
                    
                    Text(status.displayName)
                        .fontStyle(AppFont.body5)
                        .foregroundColor(.Text)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.Card.opacity(0.95))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.top, 12)
                .padding(.trailing, 12)
            }
        }
    }
    
    private var statusColor: Color {
        switch character.status {
        case .alive:
            return Color.green
        case .dead:
            return Color.red
        default:
            return Color.gray
        }
    }
    
    private func genderIcon(_ gender: String) -> String {
        switch gender.lowercased() {
        case "male":
            return "person.fill"
        case "female":
            return "person.fill"
        default:
            return "person.fill"
        }
    }
}
