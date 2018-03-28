import UIKit

let maxRedValue: CGFloat = 1.0
let maxGreenValue: CGFloat = 1.0
let maxBlueValue: CGFloat = 1.0
let maxYellowValue: CGFloat = 1.0

enum RGBColorError: Error {
    case invalidRedValue
    case invalidGreenValue
    case invalidBlueValue
    
    case undefinedRedComponent
    case undefinedGreenComponent
    case undefinedBlueComponent
}

public class RYBColor: ColorConverter {
    
    public var red: CGFloat
    public var yellow: CGFloat
    public var blue: CGFloat
    
    init(red: CGFloat, yellow: CGFloat, blue: CGFloat) {
        self.red = red
        self.yellow = yellow
        self.blue = blue
    }
    
    /**
     Converts from the RGB color system to the RYB color system.
     
     - parameters:
     - color: The RGB color to be converted.
     
     - throws: An error of type 'RGBColorError'
     
     */
    public func fromRGBColor(color: UIColor) throws {
        
        guard color.rgbColorComponent?.red != nil else {
            throw RGBColorError.undefinedRedComponent
        }
        
        guard color.rgbColorComponent!.red >= 0.0 && color.rgbColorComponent!.red <= maxRedValue else {
            throw RGBColorError.invalidRedValue
        }
        
        guard color.rgbColorComponent?.green != nil else {
            throw RGBColorError.undefinedGreenComponent
        }
        
        guard color.rgbColorComponent!.green >= 0.0 && color.rgbColorComponent!.green <= maxGreenValue else {
            throw RGBColorError.invalidGreenValue
        }
        
        guard color.rgbColorComponent?.blue != nil else {
            throw RGBColorError.undefinedBlueComponent
        }
        
        guard color.rgbColorComponent!.blue >= 0.0 && color.rgbColorComponent!.blue <= maxBlueValue else {
            throw RGBColorError.invalidBlueValue
        }
        
        var red = color.rgbColorComponent!.red
        var green = color.rgbColorComponent!.green
        var blue = color.rgbColorComponent!.blue
        
        // remove white from RGB color
        let white = min(red, green, blue)
        red -= white
        green -= white
        blue -= white
        
        let maxGreen = max(red, green, blue)
        
        // get yellow out of red and green
        var yellow = min(red, green)
        red -= yellow
        green -= yellow
        
        // if the conversion combines blue and green, then cut each in half to preserve the value's maximum range
        if blue > 0 && green > 0 {
            blue /= 2
            green /= 2
        }
        
        // redistribute the remaining green
        yellow += green
        blue += green
        
        // normalize
        let maxYellow = max(red, yellow, blue)
        if maxYellow > 0 {
            let normalized = maxGreen/maxYellow
            red *= normalized
            yellow *= normalized
            blue *= normalized
        }
        
        // add the white back in
        red += white
        yellow += white
        blue += white
        
        // update class variables
        self.red = red
        self.yellow = yellow
        self.blue = blue

    }
 
    /**
     Converts from the RYB color system to the RGB color system
     - returns: A new RGB color
     */
    public func toRGBColor() -> UIColor {
        var red = self.red
        var yellow = self.yellow
        var blue = self.blue
        
        // remove white from RYB color
        let white = min(red, yellow, blue)
        red -= white
        yellow -= white
        blue -= white
        
        let maxYellow = max(red, yellow, blue)
        
        // get green out of yellow and blue
        var green = min(yellow, blue)
        yellow -= green
        blue -= green
        
        if blue > 0 && green > 0 {
            blue *= 2
            green *= 2
        }
        
        // redistribute the remaining yellow
        red += yellow
        green += yellow
        
        // normalize
        let maxGreen = max(red, green, blue)
        if maxGreen > 0 {
            let normalized = maxYellow/maxGreen
            red *= normalized
            green *= normalized
            blue *= normalized
        }
        
        // add the white back in
        red += white
        green += white
        blue += white
    
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    /**
     Mixes two RYB colors together.
     
     - parameters:
     - color: The color you want to mix
     */
    public func mix(withColor color: RYBColor) {
        let r = self.red + color.red
        let y = self.yellow + color.yellow
        let b = self.blue + color.blue
        
        let maxValue = max(r, y, b)
        
        let newRed = (r / maxValue)
        let newYellow = (y / maxValue)
        let newBlue = (b / maxValue)
        
        self.red = newRed
        self.yellow = newYellow
        self.blue = newBlue
    }
}

// extension for getting color components
extension UIColor {
    var rgbColorComponent: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let components = self.cgColor.components else { return nil }
    
        return (
            red: components[0],
            green: components[1],
            blue: components[2],
            alpha: components[3]
        )
    }
}
