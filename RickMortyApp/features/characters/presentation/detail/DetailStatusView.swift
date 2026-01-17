import SwiftUI

struct DetailStatusView: View {
    var character: Character? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(statusColor)
                .frame(width: 14, height: 14)
                .shadow(color: statusColor.opacity(0.5), radius: 4, x: 0, y: 0)
            
            Text(character?.status?.displayName ?? "")
                .fontStyle(AppFont.body3)
                .redacted(reason: character?.status == nil ? .placeholder : [])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
    
    private var statusColor: Color {
        switch character?.status {
        case .alive:
            return Color.green
        case .dead:
            return Color.red
        default:
            return Color.gray
        }
    }
}

struct DetailStatusView_Previews: PreviewProvider {
    static var previews: some View {
        DetailStatusView()
    }
}
