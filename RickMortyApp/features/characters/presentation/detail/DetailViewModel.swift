import Foundation
import SwiftUI

@MainActor
final class DetailViewModel: ObservableObject {
    private let getCharacterDetail: GetCharacterDetail
    @Published var character: Character?
    @Published var details: [KeyValueModel] = []

    init(getCharacterDetail: GetCharacterDetail) {
        self.getCharacterDetail = getCharacterDetail
    }

    func loadDetail(characterId: Int) async {
        do {
            let response = try await getCharacterDetail.execute(characterId: characterId)
            character = response
            details = getDetails(character: response)
        } catch {
            Log.error("Failed to load detail: \(error.localizedDescription)")
        }
    }

    func getDetails(character: Character) -> [KeyValueModel] {
        var list: [KeyValueModel] = []
        
        // Nombre
        if !character.name.isEmpty {
            list.append(
                KeyValueModel(
                    id: 0,
                    key: String(localized: "text_name"),
                    value: character.name
                )
            )
        }
        
        // Estado
        if let status = character.status {
            list.append(
                KeyValueModel(
                    id: 1,
                    key: "Status",
                    value: status.displayName
                )
            )
        }
        
        // Especie
        if let species = character.species, !species.isEmpty {
            list.append(
                KeyValueModel(
                    id: 2,
                    key: String(localized: "text_species"),
                    value: species
                )
            )
        }
        
        // Género
        if let gender = character.gender, !gender.isEmpty {
            list.append(
                KeyValueModel(
                    id: 3,
                    key: String(localized: "text_gender"),
                    value: gender
                )
            )
        }
        
        // Tipo (si existe)
        if let type = character.type, !type.isEmpty {
            list.append(
                KeyValueModel(
                    id: 4,
                    key: "Type",
                    value: type
                )
            )
        }
        
        // Origen
        if let originName = character.origin?.name, !originName.isEmpty {
            list.append(
                KeyValueModel(
                    id: 5,
                    key: String(localized: "text_last_know_location"),
                    value: originName
                )
            )
        }
        
        // Ubicación actual
        if let locationName = character.location?.name, !locationName.isEmpty {
            list.append(
                KeyValueModel(
                    id: 6,
                    key: String(localized: "text_location"),
                    value: locationName
                )
            )
        }
        
        // Número de episodios
        if !character.episodeURLs.isEmpty {
            list.append(
                KeyValueModel(
                    id: 7,
                    key: "Episodes",
                    value: "\(character.episodeURLs.count)"
                )
            )
        }
        
        // Fecha de creación (formateada)
        if let created = character.created {
            list.append(
                KeyValueModel(
                    id: 8,
                    key: "Created",
                    value: formatDate(created)
                )
            )
        }
        
        return list
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}
