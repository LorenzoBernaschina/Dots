import Foundation

public protocol Difficulty {
    func setGame() -> [RYBColor]
    func randomColor() -> RYBColor
}

extension Difficulty {
    public func goalColor(forColorsPalette palette: [RYBColor], withNumberOfMix mixes: Int) -> RYBColor? {
        var mixer = [RYBColor]()
        for color in palette {
            let newColor = RYBColor(red: color.red, yellow: color.yellow, blue: color.blue)
            mixer.append(newColor)
        }
        
        var goalColor: RYBColor?
        for _ in 0 ..< mixes {
            let randomIndex = self.randomIndexForRange(range: 0 ..< mixer.count)
            
            if (goalColor == nil) {
                goalColor = mixer[randomIndex]
            }else {
                goalColor!.mix(withColor: mixer[randomIndex])
            }
            
            mixer.remove(at: randomIndex)
        }
        
        return goalColor
    }
    
    public func isInvalidGoalColor(goalColor: RYBColor?, forPalette palette: [RYBColor]) -> Bool {
        guard goalColor != nil else { return true }
        
        // white color
        if goalColor!.red == 1.0 && goalColor!.yellow == 1.0 && goalColor!.blue == 1.0 {
            return true
        }
        
        for color in palette {
            if (color.red == goalColor!.red && color.yellow == goalColor!.yellow && color.blue == goalColor!.blue) {
                return true
            }else if (abs(color.red - goalColor!.red) <= 0.25 && abs(color.yellow - goalColor!.yellow) <= 0.25 && abs(color.blue - goalColor!.blue) <= 0.25){
                return true
            }
        }
        
        return false
    }
    
    public func isInvalidColorsPalette(forPalette palette: [RYBColor]) -> Bool {
        for i in 0 ..< (palette.count - 1) {
            if (palette[i].red != palette[i+1].red || palette[i].yellow != palette[i+1].yellow || palette[i].blue != palette[i+1].blue) {
                return false
            }
        }
        return true
    }
    
    public func randomIndexForRange(range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}
