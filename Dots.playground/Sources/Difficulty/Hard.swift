import UIKit
import Foundation

public class Hard: Difficulty {
    
    private let NUMBER_OF_MIX = 7
    
    private var colorsPalette: [RYBColor]
    
    public init() {
        self.colorsPalette = [RYBColor]()
    }
    
    public func setGame() -> [RYBColor] {
        // #1 Generate colors randomly
        repeat {
            print("calc hard palette")
            self.colorsPalette.removeAll()
            for _ in 0 ..< 9 {
                let color = randomColor()
                self.colorsPalette.append(color)
            }
        } while (self.isInvalidColorsPalette(forPalette: self.colorsPalette))
        
        // #2 Mix colors randomly to set a goal color
        var goal: RYBColor?
        repeat {
            print("calc hard goal")
            goal = self.goalColor(forColorsPalette: self.colorsPalette, withNumberOfMix: NUMBER_OF_MIX)
        } while (self.isInvalidGoalColor(goalColor: goal, forPalette: self.colorsPalette) || goal == nil)
        
        // #3 Add the goal color to colorsPalette array
        self.colorsPalette.append(goal!)
        
        return self.colorsPalette
    }
    
    
    public func randomColor() -> RYBColor {
        var randomRYBColorValues: [CGFloat] = [CGFloat(0.0), CGFloat(0.0), CGFloat(0.0)]
        
        // generates primary, secondary and tertiary colors
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
