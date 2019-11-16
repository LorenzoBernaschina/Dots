/**
 This class is a singleton that provides the constant values across the whole app
*/

import UIKit

//MARK: View
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

//MARK: Button
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

//MARK: Image
public struct Image {
    public var x: CGFloat
    public var y: CGFloat
    public var width: CGFloat
    public var height: CGFloat
    public var name: String
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, name: String) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.name = name
    }
}

enum ImageType {
    case Welcome
    case Help
    
    func get() -> Image {
        switch self {
        case .Welcome:
            return Image(x: 0, y: 0, width: 600, height: 600, name: "WelcomeBackground.jpg")
        case .Help:
            return Image(x: 0, y: 0, width: 600, height: 600, name: "HelpBackground.jpg")
        }
    }
}

// MARK: Sound
public struct Sound {
    public var name: String
    public var type: String
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

enum SoundType {
    case Welcome
    case Easy
    case Medium
    case Hard
    
    func get() -> Sound {
        switch self {
        case .Welcome:
            return Sound(name: "Welcome", type: "mp3")
        case .Easy:
            return Sound(name: "Easy", type: "mp3")
        case .Medium:
            return Sound(name: "Medium", type: "mp3")
        case .Hard:
            return Sound(name: "Hard", type: "mp3")
        }
    }
}

public class ConstantValues {
    
    public static let shared = ConstantValues()
    
    public let gameView = ViewType.Game.get()
    
    public let paletteView = ViewType.Palette.get()
    
    public let easyButton = ButtonType.Easy.get()
    
    public let mediumButton = ButtonType.Medium.get()
    
    public let hardButton = ButtonType.Hard.get()
    
    public let resetButton = ButtonType.Reset.get()
    
    public let dismissButton = ButtonType.Dismiss.get()
    
    public let helpButton = ButtonType.Help.get()
    
    public let welcomeBackgroundImage = ImageType.Welcome.get()
    
    public let helpBackgroundImage = ImageType.Help.get()
    
    public let welcomeSoundtrack = SoundType.Welcome.get()
    
    public let easySoundtrack = SoundType.Easy.get()
    
    public let mediumSoundtrack = SoundType.Medium.get()
    
    public let hardSoundtrack = SoundType.Hard.get()
    
}

