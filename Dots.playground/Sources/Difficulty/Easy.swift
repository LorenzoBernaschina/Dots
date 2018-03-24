import UIKit
import Foundation

public class Easy: Difficulty {
    
    private let NUMBER_OF_MIX = 3
    
    private var colorsPalette: [RYBColor]
    
    public init() {
        self.colorsPalette = [RYBColor]()
    }
    
    public func setGame() -> [RYBColor] {
        // #1 Generate colors randomly
        repeat {
            print("calc easy palette")
            self.colorsPalette.removeAll()
            for _ in 0 ..< 9 {
                let color = randomColor()
                self.colorsPalette.append(color)
            }
        } while (self.isInvalidColorsPalette(forPalette: self.colorsPalette))
        
        // #2 Mix colors randomly to set a goal color
        var goal: RYBColor?
        repeat {
            print("calc easy goal")
            goal = self.goalColor(forColorsPalette: self.colorsPalette, withNumberOfMix: NUMBER_OF_MIX)
        } while (self.isInvalidGoalColor(goalColor: goal, forPalette: self.colorsPalette) || goal == nil)

        // #3 Add the goal color to colorsPalette array
        self.colorsPalette.append(goal!)
        
        return self.colorsPalette
    }
    
    
    /// This method generates random colors that will be used for the game palette
    public func randomColor() -> RYBColor {
        
        var randomRYBColorValues: [CGFloat] = [CGFloat(0.0), CGFloat(0.0), CGFloat(0.0)]
        
        // generates only primary colors
        let index = self.randomIndexForRange(range: 0 ..< randomRYBColorValues.count)
        randomRYBColorValues[index] = CGFloat(1.0)
        
        let color = RYBColor(red: randomRYBColorValues[0],
                             yellow: randomRYBColorValues[1],
                             blue: randomRYBColorValues[2])
        return color
    }

}
