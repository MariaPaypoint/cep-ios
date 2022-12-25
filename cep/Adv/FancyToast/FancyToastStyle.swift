//  Created by Maria Novikova on 24.12.2022.

import Foundation
import SwiftUI

enum FancyToastStyle {
    case error
    case warning
    case success
    case info
}

extension FancyToastStyle {
    var themeLeftColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    
    var themeBgColor: Color {
        switch self {
        case .error: return Color(uiColor: UIColor(named: "ErrorBg")!)
        case .warning: return Color(uiColor: UIColor(named: "WarningBg")!)
        case .info: return Color(uiColor: UIColor(named: "InfoBg")!)
        case .success: return Color(uiColor: UIColor(named: "SuccessBg")!)
        }
    }
    
    var themeTextColor: Color {
        switch self {
        case .error: return Color(uiColor: UIColor(named: "ErrorText")!)
        case .warning: return Color(uiColor: UIColor(named: "WarningText")!)
        case .info: return Color(uiColor: UIColor(named: "InfoText")!)
        case .success: return Color(uiColor: UIColor(named: "SuccessText")!)
        }
    }
    
    var themeBorderColor: Color {
        switch self {
        case .error: return Color(uiColor: UIColor(named: "ErrorBorder")!)
        case .warning: return Color(uiColor: UIColor(named: "WarningBorder")!)
        case .info: return Color(uiColor: UIColor(named: "InfoBorder")!)
        case .success: return Color(uiColor: UIColor(named: "SuccessBorder")!)
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}
