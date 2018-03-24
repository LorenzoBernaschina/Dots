import UIKit
import Foundation

public class Easy: Difficulty {
    
    private var colorsPalette: [RYBColor]
    let NUMBER_OF_MIX = 3
    
    public init() {
        self.colorsPalette = [RYBColor]()
    }
    
    public func setGame() -> [RYBColor] {
        // #1 Generate colors randomly
        repeat {
            self.colorsPalette.removeAll()
            for _ in 0 ..< 9 {
                let color = randomColor()
                self.colorsPalette.append(color)
            }
        } while (self.isInvalidColorsPalette(forPalette: self.colorsPalette))
        
        // #2 Mix colors randomly to set a goal color
        var goal: RYBColor?
        repeat {
            goal = self.goalColor()
        } while (self.isInvalidGoalColor(goalColor: goal, forPalette: self.colorsPalette) || goal == nil)

        // #3 Add the goal color to colorsPalette array
        self.colorsPalette.append(goal!)
        
        return colorsPalette
    }
    
    private func goalColor() -> RYBColor? {
        var mixer = [RYBColor]()
        for color in self.colorsPalette {
            let newColor = RYBColor(red: color.red, yellow: color.yellow, blue: color.blue)
            mixer.append(newColor)
        }
        
        var goalColor: RYBColor?
        var mixed = 0
        while mixed < NUMBER_OF_MIX {
            let randomIndex = self.randomIndexForRange(range: 0 ..< mixer.count)
            
             print("color: r: \(mixer[randomIndex].red) y: \(mixer[randomIndex].yellow) b: \(mixer[randomIndex].blue)")
            
            if (goalColor == nil) {
                goalColor = mixer[randomIndex]
            }else {
                goalColor!.mix(withColor: mixer[randomIndex])
            }
            
             print("mixed color: r: \(goalColor!.red) y: \(goalColor!.yellow) b: \(goalColor!.blue)")
            
            mixer.remove(at: randomIndex)
            
            mixed += 1
        }
        
        return goalColor
    }
    
    private func isInvalidGoalColor(goalColor: RYBColor?, forPalette palette: [RYBColor]) -> Bool {
        guard goalColor != nil else { return true }
        for color in palette {
            if (color.red == goalColor!.red && color.yellow == goalColor!.yellow && color.blue == goalColor!.blue) {
                return true
            }
        }
        return false
    }

    /// This method generates random colors that will be used for the game palette
    private func randomColor() -> RYBColor {
        
        var randomRYBColorValues: [CGFloat] = [CGFloat(0.0), CGFloat(0.0), CGFloat(0.0)]
        
        // generates only primary colors
        let index = self.randomIndexForRange(range: 0 ..< randomRYBColorValues.count)
        randomRYBColorValues[index] = CGFloat(1.0)
        
        let color = RYBColor(red: randomRYBColorValues[0],
                             yellow: randomRYBColorValues[1],
                             blue: randomRYBColorValues[2])
        return color
    }
    
    private func isInvalidColorsPalette(forPalette palette: [RYBColor]) -> Bool {
        for i in 0 ..< (palette.count - 1) {
            if (palette[i].red != palette[i+1].red || palette[i].yellow != palette[i+1].yellow || palette[i].blue != palette[i+1].blue) {
                return false
            }
        }
        return true
    }
    
    private func randomIndexForRange(range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}
