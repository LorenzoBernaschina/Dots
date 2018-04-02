import UIKit
import Foundation

public class Hard: Difficulty {
    
    private let NUMBER_OF_MIX = 7
    
    private var colorsPalette: [RYBColor]
    
    public init() {
        self.colorsPalette = [RYBColor]()
    }
    
    /**
     Manages the logic to set a new game.
     The algorithm creates an initial palette of random colors, then mix an arbitrary amount of them to gain a final goal color.
     
     - returns:
     An array of RYBColor containing in the first 9 positions the original color palette that will be displayed, followed by the colors selected during the mix process. Use this second part of the array to provide suggestions to the user in case he needs help. The last element of the array is always the final goal color that the user has to reach during the game.
     */
    public func setGame() -> [RYBColor] {
        // #1 Generate colors randomly to set a colors palette
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
            goalPalette = self.goalColor(forColorsPalette: self.colorsPalette, withNumberOfMix: NUMBER_OF_MIX)
        } while (self.isInvalidGoalColor(goalColor: goalPalette, forPalette: self.colorsPalette))
        
        // #3 Add the goalPalette to colorsPalette array
        self.colorsPalette.append(contentsOf: goalPalette)
        
        return self.colorsPalette
    }
    
    /**
     This method generates random primary, secondary and tertiary colors that will be used for the game palette.
     
     - returns:
     A random primary, secondary or tertiary RYBColor.
     
     Please note that since this is the hard level, the initial color palette may be composed by primary, secondary and tertiary colors together.
     */
    public func randomColor() -> RYBColor {
        var randomRYBColorValues: [CGFloat] = [CGFloat(0.0), CGFloat(0.0), CGFloat(0.0)]
        
        //primary and secondary
        let numberOfIndexes = self.randomIndexForRange(range: 1 ..< 3)
        let bound = self.randomIndexForRange(range: 0 ..< randomRYBColorValues.count)
        
        for i in 0 ..< numberOfIndexes {
            if i % 2 == 0 {
                let index = self.randomIndexForRange(range: 0 ..< bound)
                randomRYBColorValues[index] = CGFloat(1.0)
            } else {
                let index = self.randomIndexForRange(range: bound ..< randomRYBColorValues.count)
                randomRYBColorValues[index] = CGFloat(1.0)
            }
        }
        
        //tertiary
        //if the color is secondary randomly decide to transform it in tertiary
        if (randomRYBColorValues[0] + randomRYBColorValues[1] + randomRYBColorValues[2] == 2){
            let index = self.randomIndexForRange(range: 0 ..< 2)
            randomRYBColorValues[index] /= 2
        }
        
        let color = RYBColor(red: randomRYBColorValues[0],
                             yellow: randomRYBColorValues[1],
                             blue: randomRYBColorValues[2])
        return color
    }
    
}
