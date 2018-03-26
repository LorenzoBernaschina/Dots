import UIKit

public struct View {
    public var x: CGFloat
    public var y: CGFloat
    public var width: CGFloat
    public var height: CGFloat
    public var backgroundColor: UIColor
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, backgroundColor: UIColor) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.backgroundColor = backgroundColor
    }
}

enum ViewType {
    case Game
    case Palette
    
    func get() -> View {
        switch self {
        case .Game:
            return View(x: 0, y: 0, width: 600, height: 600, backgroundColor: .white)
        case .Palette:
            return View(x: 0, y: 0, width: 600, height: 600, backgroundColor: .clear)
        }
    }
}

public struct Button {
    public var title: String
    public var x: CGFloat
    public var y: CGFloat
    public var width: CGFloat
    public var height: CGFloat
    public var cornerRadius: CGFloat
    
    init(title: String, x: CGFloat, y: CGFloat, size: CGFloat) {
        self.title = title
        self.x = x
        self.y = y
        self.width = size
        self.height = size
        self.cornerRadius = size / 2
    }
}

enum ButtonType {
    case Easy
    case Medium
    case Hard
    case Reset
    case Dismiss
    case Help
    
    func get() -> Button {
        switch self {
        case .Easy:
            return Button(title: "Easy", x: 290, y: 100, size: 220)
        case .Medium:
            return Button(title: "Medium", x: 90, y: 190, size: 190)
        case .Hard:
            return Button(title: "Hard", x: 255, y: 330, size: 160)
        case .Reset:
            return Button(title: "RefreshIcon.png", x: 520, y: 520, size: 50)
        case .Dismiss:
            return Button(title: "X", x: 30, y: 30, size: 50)
        case .Help:
            return Button(title: "?", x: 520, y: 30, size: 50)
        }
    }
}

public struct Font {
    public var name: String
    
    init(name: String) {
        self.name = name
    }
}

enum FontType {
    case SanFrancisco
    
    func get() -> Font {
        switch self {
        case .SanFrancisco:
            return Font(name: ".SFUIText-Bold")
        }
    }
}

public class ViewObject {
    
    public static let shared = ViewObject()
    
    public let gameView = ViewType.Game.get()
    
    public let paletteView = ViewType.Palette.get()
    
    public let easyButton = ButtonType.Easy.get()
    
    public let mediumButton = ButtonType.Medium.get()
    
    public let hardButton = ButtonType.Hard.get()
    
    public let resetButton = ButtonType.Reset.get()
    
    public let dismissButton = ButtonType.Dismiss.get()
    
    public let helpButton = ButtonType.Help.get()
    
    public let sanFranciscoFont = FontType.SanFrancisco.get()
}

