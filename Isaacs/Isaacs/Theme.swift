import UIKit

let selectedThemeKey = "SelectedTheme"

enum Theme: Int {
    case Default, NightMode
    
    var mainColor:UIColor {
        switch self {
        case .Default:
            return UIColor.blackColor()
        case .NightMode:
            return UIColor.lightGrayColor()
        }
    }
}

struct ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey(selectedThemeKey)?.integerValue {
            return Theme(rawValue: storedTheme)!
        }else{
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
    
        NSUserDefaults.standardUserDefaults().setValue(theme.rawValue, forKey: selectedThemeKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let sharedApplication = UIApplication.sharedApplication()
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
    }
}
