import SwiftUI

struct SettingsScreen: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    fileprivate func SettingsContentView() -> some View {
        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Card)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LocalizedStringKey("text_theme_mode"))
                            .fontStyle(AppFont.body4)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDarkMode)
                        .toggleStyle(ColoredToggleStyle())
                        .onChange(of: isDarkMode) { oldValue, newValue in
                            Log.debug("isDarkMode => \(newValue)")
                        }
                }
                
                Divider()
                    .background(Color.Text.opacity(0.1))
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LocalizedStringKey("text_app_version"))
                            .fontStyle(AppFont.body4)
                    }
                    
                    Spacer()
                    
                    Text("\(Bundle.main.appVersion)")
                        .fontStyle(AppFont.body2)
                        .foregroundColor(.Primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.Primary.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(20)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color.Background.ignoresSafeArea()
                ScrollView {
                    SettingsContentView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(LocalizedStringKey("toolbar_settings_title")).fontStyle(AppFont.title)
                    }
                }
            }
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
