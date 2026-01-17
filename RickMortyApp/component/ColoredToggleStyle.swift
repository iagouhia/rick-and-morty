import SwiftUI

struct ColoredToggleStyle: ToggleStyle {
    var onColor = Color.Primary.opacity(0.3)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.Primary
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label 
            Spacer()
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 29)
                .overlay(
                    Circle()
                        .fill(thumbColor)
                        .shadow(color: thumbColor.opacity(0.3), radius: 2, x: 0, y: 1)
                        .padding(1.5)
                        .offset(x: configuration.isOn ? 10 : -10))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
        .font(.title)
        //.padding(.horizontal)
    }
}
