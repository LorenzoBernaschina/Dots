import UIKit
import Foundation

public class Easy: Difficulty {
    
    private let NUMBER_OF_MIX = 3
    
    private var colorsPalette: [RYBColor]
    
    public init() {
        self.colorsPalette = [RYBColor]()
    }
    
    /**
     Manages the logic to set a new game.
     The algorithm creates an initial palette of random colors, then mix an arbitrary amount of these colors to gain a final goal color.
     
     - returns:
     An array of RYBColor containing in the first 9 position the original color palette that will be displayed followed by the colors selected during the mix process. Use this second part of the array to provide suggestions to the user in case he needs help. The last element of the array is the final goal color that the user has to reach during the game.
     */
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
        var goalPalette = [RYBColor]()
        repeat {
            print("easy")
            goalPalette = self.goalColor(forColorsPalette: self.colorsPalette, withNumberOfMix: NUMBER_OF_MIX)
        } while (self.isInvalidGoalColor(goalColor: goalPalette, forPalette: self.colorsPalette))

        // #3 Add the goalPalette to colorsPalette array
        self.colorsPalette.append(contentsOf: goalPalette)
        
        return self.colorsPalette
    }
    
    
    /**
     This method generates random primary colors that will be used for the game palette.
     
     - returns:
      A random primary RYBColor.
     
     Please note that since this is the easy level, the initial color palette will be composed only by primary colors.
     */
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
