public class DifficultyManager {

    private var gameDifficulty: Difficulty?
    
    public init() { }
    
    /**
     Sets a new game with a given difficulty level.
     
     - parameters:
        - level: The difficulty level of the game to be set. This value needs to be an instance of Easy, Medium or Hard classes. According with the level will be performed a different algorithm to set the game.
     
     - returns:
        An array of RYBColor containing the initial color palette to be displayed, the colors selected by the algorithm during the process of setting a goal color and the goal color itself always in the last position.
    */
    public func setGame(withDifficultyLevel level: Difficulty) -> [RYBColor] {
        self.gameDifficulty = level
        return self.gameDifficulty!.setGame()
    }
}
