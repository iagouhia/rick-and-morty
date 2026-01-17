import Foundation
import SwiftUI

struct AppFont {
    static let title = FontStyle(font: Font.custom(FontType.bold.rawValue, size: 24.0),
                                    weight: .bold,
                                    foregroundColor: Color.Text,
                                    lineSpacing: 2.0)
    
    static let heading = FontStyle(font: Font.custom(FontType.semi_bold.rawValue, size: 20.0),
                                      weight: .semibold,
                                      foregroundColor: Color.Text,
                                      lineSpacing: 4.0)
    
    static let heading2 = FontStyle(font: Font.custom(FontType.semi_bold.rawValue, size: 18.0),
                                      weight: .semibold,
                                      foregroundColor: Color.ToggleRed,
                                      lineSpacing: 4.0)
    
    static let body = FontStyle(font: Font.custom(FontType.regular.rawValue, size: 15.0),
                                   weight: .regular,
                                   foregroundColor: .Text,
                                   lineSpacing: 4.0)
    
    static let body2 = FontStyle(font: Font.custom(FontType.medium.rawValue, size: 15.0),
                                   weight: .medium,
                                   foregroundColor: .Text,
                                   lineSpacing: 4.0)
    
    static let body3 = FontStyle(font: Font.custom(FontType.bold.rawValue, size: 17.0),
                                   weight: .bold,
                                   foregroundColor: .Text,
                                   lineSpacing: 4.0)
    
    static let body4 = FontStyle(font: Font.custom(FontType.semi_bold.rawValue, size: 15.0),
                                   weight: .semibold,
                                   foregroundColor: .Text,
                                   lineSpacing: 4.0)
    
    static let body5 = FontStyle(font: Font.custom(FontType.medium.rawValue, size: 13.0),
                                   weight: .medium,
                                   foregroundColor: .Text,
                                   lineSpacing: 3.0)
    
    static let body6 = FontStyle(font: Font.custom(FontType.regular.rawValue, size: 14.0),
                                   weight: .regular,
                                   foregroundColor: .Text,
                                   lineSpacing: 4.0)
}
