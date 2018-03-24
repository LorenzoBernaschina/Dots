public class DifficultyManager {

    private var gameDifficulty: Difficulty?
    
    public init() { }
    
    public func setGameColorPalette(withDifficultyLevel level: Difficulty) -> [RYBColor] {
        self.gameDifficulty = level
        return self.gameDifficulty!.setGame()
    }
}
