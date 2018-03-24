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
    public var color: UIColor
    
    init(title: String, x: CGFloat, y: CGFloat, size: CGFloat, color: UIColor) {
        self.title = title
        self.x = x
        self.y = y
        self.width = size
        self.height = size
        self.cornerRadius = size / 2
        self.color = color
    }
}

enum ButtonType {
    case Easy
    case Medium
    case Hard
    case Dismiss
    case Help
    
    func get() -> Button {
        switch self {
        case .Easy:
            return Button(title: "Easy", x: 10, y: 10, size: 100, color: .blue)
        case .Medium:
            return Button(title: "Medium", x: 10, y: 150, size: 100, color: .yellow)
        case .Hard:
            return Button(title: "Hard", x: 10, y: 290, size: 100, color: .red)
        case .Dismiss:
            return Button(title: "X", x: 0, y: 0, size: 30, color: .white)
        case .Help:
            return Button(title: "?", x: 0, y: 0, size: 30, color: .white)
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
}

