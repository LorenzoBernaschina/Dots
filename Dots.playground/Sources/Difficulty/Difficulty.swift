import Foundation

public protocol Difficulty {
    func setGame() -> [RYBColor]
    func randomColor() -> RYBColor
}

extension Difficulty {
    
    /**
     Mix the palette colors randomly to obtain a goal color that the user has to reach during the game.
     - parameters:
        - palette: an array of RYB colors that contains the initial color palette for the game
        - mix: the number of mix to be done before to obtain a goal color
     
     - returns:
        - An array of RYB colors that contains in the first 9 positions the original color palette passed as parameter, followed by every intermediate color selected during the mixing process ordered chronologically. Use the intermediate colors to help the user choosing the right ones to mix after an arbitrary amount of inactivity time during the game.
     
        The last element of the array is the final goal color that the user has to reach during the game
    */
    public func goalColor(forColorsPalette palette: [RYBColor], withNumberOfMix mix: Int) -> [RYBColor] {
        var mixer = [RYBColor]()
        for color in palette {
            let newColor = RYBColor(red: color.red, yellow: color.yellow, blue: color.blue)
            mixer.append(newColor)
        }
        
        var solution = [RYBColor]()
        
        var goalColor: RYBColor?
        for _ in 0 ..< mix {
            let randomIndex = self.randomIndexForRange(range: 0 ..< mixer.count)
            
            if (goalColor == nil) {
                goalColor = mixer[randomIndex]
            }else {
                goalColor!.mix(withColor: mixer[randomIndex])
            }
            
            let newGoalColor = RYBColor(red: mixer[randomIndex].red, yellow: mixer[randomIndex].yellow, blue: mixer[randomIndex].blue)
            
            solution.append(newGoalColor)
            
            mixer.remove(at: randomIndex)
        }
        
        solution.append(goalColor!)
        
        return solution
    }
    
    /**
     Checks the validity of the goal color found.
     
     - parameters:
        - goalColor: The color that the user has to reach during the game.
        - palette: The color palette provided to the user at the beginning of the game.
     
     - returns:
        A boolean value indicating if the selected goal color is valid or not.
        If the goal color is white or its components are too similar with the components of another color in the palette, it returns false, otherwise true.
     */
    public func isInvalidGoalColor(goalColor: [RYBColor], forPalette palette: [RYBColor]) -> Bool {
        let c = goalColor.last
        
        if c!.red == 1.0 && c!.yellow == 1.0 && c!.blue == 1.0 {
            return true
        }
        
        for color in palette {
            if (abs(color.red - c!.red) <= 0.3 && abs(color.yellow - c!.yellow) <= 0.3 && abs(color.blue - c!.blue) <= 0.3){
                return true
            }
        }
        
        return false
    }
    
    /**
     Checks the validity of the color palette
     
     - parameters:
        - palette: The color palette provided to the user at the beginning of the game.
     
     - returns:
        A boolean value indicating if the color palette is valid or not.
        If the palette is monochromatic, it returns false, otherwise true.
        This means that in order to be valid a color palette should own at least two different colors.
     */
    public func isInvalidColorsPalette(forPalette palette: [RYBColor]) -> Bool {
        for i in 0 ..< (palette.count - 1) {
            if (palette[i].red != palette[i+1].red || palette[i].yellow != palette[i+1].yellow || palette[i].blue != palette[i+1].blue) {
                return false
            }
        }
        return true
    }
    
    /**
     Provides a random index within the given range.
     Use this method for making random color selections and mix.
     
     - parameters:
        - range: The interval of valid random index
     
     - returns:
        A random integer value within the range
    */
    public func randomIndexForRange(range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}
