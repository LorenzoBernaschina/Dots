import SpriteKit

public protocol GamePaletteDelegate: class {
    /**
     Called every time the user mixes two colors combining two dots together.
     Use this method for any check or update on the game status after every move.
     
     - parameters:
     - dot: The covered SKNode during the drag and drop action. Use this parameter to check the updates performed on the covered dot, in particular its color property containing the result of the mix.
     
     - Important:
     During every move action there are two actors involved: a 'selected dot' that is the first one selected by the user and dragged around the screen and a second one called 'covered dot'.
     The covered dot is the one where the user has dropped the selected one.
     
     Please note that after every move the first selected dot is removed from the scene and remains only the covered dot colored with the result of the mix between them.
    */
    func dotDidMove(withNewDot dot: SKNode)
}

public class GamePalette: SKScene {
    
    override public init(size: CGSize) {
        super.init(size: size)
    }
    
    required public init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // To manage dragging
    private var touch: UITouch?
    
    // Stores the difference between the touch location and the center of the sprite
    // This value is used for dragging exactly from the selected point inside the node instead of its anchor point as happens by default
    private var offset: CGPoint?
    
    // To manage the selected dot
    private var selectedDot: SKNode?
    
    // To manage the covered dot
    private var coveredDot: SKNode?
    
    
    // Dots animations
    private let selectionZoomIn = SKAction.scale(to: 1.1, duration: 0.25)
    private let selectionFadeAlpha = SKAction.fadeAlpha(to: 0.8, duration: 0.25)
    private var selectionAnimation: SKAction?
    
    private let deselectionZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private let deselectionFadeAlpha = SKAction.fadeIn(withDuration: 0.25)
    private var deselectionAnimation: SKAction?
    
    private let coverZoomIn = SKAction.scale(to: 1.3, duration: 0.25)
    private let coverFadeAlpha = SKAction.fadeAlpha(to: 0.6, duration: 0.25)
    private var coverAnimation: SKAction?
    
    private let uncoverZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private let uncoverFadeAlpha = SKAction.fadeIn(withDuration: 0.25)
    private var uncoverAnimation: SKAction?
    
    // Mix colors animations
    private let removingDotScale = SKAction.scale(to: 0.0, duration: 0.25)
    private let removingDotFadeOut = SKAction.fadeOut(withDuration: 0.25)
    private let removingDotFromParent = SKAction.removeFromParent()
    private var removeDotAnimation: SKAction?
    
    private let colorizingDotFirstScale = SKAction.scale(to: 0.8, duration: 0.2)
    private let colorizingDotSecondScale = SKAction.scale(to: 1.1, duration: 0.2)
    private let colorizingDotThirdScale = SKAction.scale(to: 1.0, duration: 0.2)
    private var colorizingDotAnimationScale: SKAction?
    
    // Suggestion animation
    private let suggestionZoomIn = SKAction.scale(to: 1.2, duration: 0.25)
    private let suggestionFadeAlphaOut = SKAction.fadeAlpha(to: 0.8, duration: 0.25)
    private let suggestionFadeAlphaIn = SKAction.fadeIn(withDuration: 0.25)
    private let suggestionZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private var suggestionAnimation: SKAction?
    
    // delegate
    public weak var gamePaletteDelegate: GamePaletteDelegate?
    
    override public func didMove(to view: SKView) {
        // animations setup
        self.selectionAnimation = SKAction.group([self.selectionZoomIn,
                                                  self.selectionFadeAlpha])
        
        self.deselectionAnimation = SKAction.group([self.deselectionZoomOut,
                                                    self.deselectionFadeAlpha])
        
        self.coverAnimation = SKAction.group([self.coverZoomIn,
                                                self.coverFadeAlpha])
        
        self.uncoverAnimation = SKAction.group([self.uncoverZoomOut,
                                                   self.uncoverFadeAlpha])
        
        let removingDotAnimation = SKAction.group([self.removingDotScale,
                                                   self.removingDotFadeOut])
        self.removeDotAnimation = SKAction.sequence([removingDotAnimation,
                                                     self.removingDotFromParent])
        
        self.colorizingDotAnimationScale = SKAction.sequence([self.colorizingDotFirstScale,
                                                              self.colorizingDotSecondScale,
                                                              self.colorizingDotThirdScale])
        
        let suggestionFirstAnimation = SKAction.group([self.suggestionZoomIn,
                                                       self.suggestionFadeAlphaOut])
        let suggestionSecondAnimation = SKAction.group([self.suggestionFadeAlphaIn,
                                                        self.suggestionZoomOut])
        self.suggestionAnimation = SKAction.sequence([suggestionFirstAnimation,
                                                      suggestionSecondAnimation])
    }
    
    // MARK: Drag and drop events manager
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            self.selectedDot = atPoint(location)
            
            if self.selectedDot!.isKind(of: Dot.self){
                
                self.selectedDot!.run(self.selectionAnimation!)
                
                self.selectedDot!.zPosition = 1.0
                
                (self.selectedDot as! Dot).originalPosition = self.selectedDot!.position
                
                self.offset = location - self.selectedDot!.position
                
                self.touch = touch as UITouch
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if self.touch != nil {
                if touch as UITouch == self.touch! {
                    
                    let location = touch.location(in: self)
                    
                    if let offset = self.offset {
                        self.selectedDot?.position = location + offset
                    }
                    
                    let dots = nodes(at: self.selectedDot!.position)
                    for dot in dots {
                        if let coveredDot = self.coveredDot {
                            if dots.count == 1 {
                                self.animate(dot: coveredDot, withAnimation: self.uncoverAnimation)
                                self.coveredDot = nil
                            }
                        }else if dot != self.selectedDot {
                            self.coveredDot = dot
                            self.animate(dot: self.coveredDot, withAnimation: self.coverAnimation)
                        }
                    }
                }
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if self.touch != nil {
                if touch as UITouch == self.touch {
                    
                    // If the user has released a dot over another one, this means he wants to mix them
                    if let coveredDot = self.coveredDot {
                        
                        // #1 remove the selected dot
                        self.animate(dot: self.selectedDot, withAnimation: self.removeDotAnimation)
                        
                        // #2 update the covered dot color
                        (coveredDot as! Dot).dotColor.mix(withColor: (self.selectedDot as! Dot).dotColor)
                        
                        // #3 animate the covered dot
                        let newColor = (coveredDot as! Dot).dotColor.toRGBColor()
                        let colorizingDotAnimationColor = SKAction.colorize(with: newColor,
                                                                       colorBlendFactor: 1.0,
                                                                       duration: 0.4)
                        let colorizingDotAnimationFadeIn = SKAction.fadeIn(withDuration: 0.1)
                        let colorizeDotAnimation = SKAction.group([self.colorizingDotAnimationScale!,
                                                                   colorizingDotAnimationColor,
                                                                   colorizingDotAnimationFadeIn])
                        self.animate(dot: coveredDot, withAnimation: colorizeDotAnimation)
                        
                        // call delegate method when the move is performed
                        self.gamePaletteDelegate?.dotDidMove(withNewDot: coveredDot)
                    }else {
                        self.selectedDot!.zPosition = 0.0
                        let moveToOriginalPosition = SKAction.move(to: (self.selectedDot as! Dot).originalPosition, duration: 0.25)
                        let moveToOriginalPositionAnimation = SKAction.group([self.deselectionAnimation!, moveToOriginalPosition])
                        self.animate(dot: self.selectedDot, withAnimation: moveToOriginalPositionAnimation)
                    }
                    
                    self.touch = nil
                    self.selectedDot = nil
                    self.offset = nil
                    self.coveredDot = nil
                }
            }
        }
    }
    
    /**
     Checks if there are two dots available on the palette in order to provide the next mix suggestion to the user.
     In case the two dots are found, it highlights them performing an animation.
     
     - parameters:
     - colorA: the first color to look for presence in the palette
     - colorB: the second color to look for presence in the palette
     
     - returns:
     A boolean value indicating the check result: returns true if a suggestion is available, false otherwise.
     */
    public func nextMoveSuggestion(forColor colorA: RYBColor, and colorB: RYBColor) -> Bool{
        var suggestionAvailable = false
        
        var firstDot: Dot!
        var secondDot: Dot!
        
        for dot in self.children {
            if (dot as! Dot).dotColor.red == colorA.red && (dot as! Dot).dotColor.yellow == colorA.yellow && (dot as! Dot).dotColor.blue == colorA.blue {
                firstDot = dot as! Dot
            }
        }
        
        if let f = firstDot {
            for dot in self.children {
                if dot != f {
                    if (dot as! Dot).dotColor.red == colorB.red && (dot as! Dot).dotColor.yellow == colorB.yellow && (dot as! Dot).dotColor.blue == colorB.blue {
                        secondDot = dot as! Dot
                        suggestionAvailable = true
                    }
                }
            }
        }
        

        if let d1 = firstDot {
            if let d2 = secondDot {
                self.animate(dot: d1, withAnimation: self.suggestionAnimation)
                self.animate(dot: d2, withAnimation: self.suggestionAnimation)
            }
        }
        
        return suggestionAvailable
    }
 
    private func animate(dot: SKNode?, withAnimation animation: SKAction?) {
        dot!.run(animation!)
    }
}

func - (left: CGPoint, right:CGPoint) -> CGPoint {
    return CGPoint(x: right.x-left.x, y: right.y-left.y)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: right.x+left.x, y: right.y+left.y)
}
