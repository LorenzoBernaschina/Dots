public class Medium: Difficulty {
    
    private var colorsPalette: [RYBColor]
    
    public init() {
        self.colorsPalette = [RYBColor]()
    }
    
    public func setGame() -> [RYBColor] {
        return self.colorsPalette
    }
}
