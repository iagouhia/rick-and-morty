import SwiftUI

struct DetailContentView: View {
    var contents: [KeyValueModel] = []
    var character: Character? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            // Card de información principal
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.Card)
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                    .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Información detallada
                    ForEach(Array(filteredContents.enumerated()), id: \.element.id) { index, content in
                        if let key = content.key, let value = content.value, !key.isEmpty {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: iconForKey(key))
                                    .font(.system(size: 16))
                                    .foregroundColor(.Primary)
                                    .frame(width: 20)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(key)
                                        .fontStyle(AppFont.body5)
                                        .foregroundColor(.Text.opacity(0.6))
                                    
                                    // Estado con badge especial
                                    if key.lowercased() == "status" {
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(statusColor(value))
                                                .frame(width: 10, height: 10)
                                                .shadow(color: statusColor(value).opacity(0.5), radius: 2, x: 0, y: 0)
                                            Text(value)
                                                .fontStyle(AppFont.body2)
                                                .foregroundColor(.Text)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(statusColor(value).opacity(0.15))
                                        .cornerRadius(8)
                                    } else {
                                        Text(value)
                                            .fontStyle(AppFont.body2)
                                            .foregroundColor(.Text)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            if index < filteredContents.count - 1 {
                                Divider()
                                    .background(Color.Text.opacity(0.1))
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
    }
    
    // No filtrar nada, mostrar toda la información
    private var filteredContents: [KeyValueModel] {
        contents
    }
    
    private func iconForKey(_ key: String) -> String {
        let lowerKey = key.lowercased()
        if lowerKey.contains("name") || lowerKey.contains("nombre") {
            return "person.fill"
        } else if lowerKey.contains("status") {
            return "heart.fill"
        } else if lowerKey.contains("especie") || lowerKey.contains("species") {
            return "sparkles"
        } else if lowerKey.contains("género") || lowerKey.contains("gender") {
            return "figure.stand"
        } else if lowerKey.contains("type") {
            return "tag.fill"
        } else if lowerKey.contains("ubicación") || lowerKey.contains("location") {
            return "mappin.circle.fill"
        } else if lowerKey.contains("origen") || lowerKey.contains("origin") {
            return "globe.americas.fill"
        } else if lowerKey.contains("episode") {
            return "tv.fill"
        } else if lowerKey.contains("created") {
            return "calendar"
        } else {
            return "info.circle.fill"
        }
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "alive":
            return Color.green
        case "dead":
            return Color.red
        default:
            return Color.gray
        }
    }
}

struct DetailContentView_Previews: PreviewProvider {
    static var previews: some View {
        DetailContentView()
    }
}
