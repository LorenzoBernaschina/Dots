import SpriteKit

public protocol GamePaletteDelegate: class {
    /**
     This method is called every time the user mix two colors during the game combining two nodes together.
     
     - parameters:
        - dot:
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
    // This value is used for dragging from the selectd point inside the node instead of its anchor point
    private var offset: CGPoint?
    
    // To manage the selected dot
    private var selectedDot: SKNode?
    
    // To manage the overlaid dot
    private var overlaidDot: SKNode?
    
    
    // Dots animations
    private let selectionZoomIn = SKAction.scale(to: 1.1, duration: 0.25)
    private let selectionFadeAlpha = SKAction.fadeAlpha(to: 0.8, duration: 0.25)
    private var selectionAnimation: SKAction?
    
    private let deselectionZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private let deselectionFadeAlpha = SKAction.fadeIn(withDuration: 0.25)
    private var deselectionAnimation: SKAction?
    
    private let overlayZoomIn = SKAction.scale(to: 1.3, duration: 0.25)
    private let overlayFadeAlpha = SKAction.fadeAlpha(to: 0.6, duration: 0.25)
    private var overlayAnimation: SKAction?
    
    private let notOverlayZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private let notOverlayFadeAlpha = SKAction.fadeIn(withDuration: 0.25)
    private var notOverlayAnimation: SKAction?
    
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
    //private let suggestionWait = SKAction.wait(forDuration: 0.25)
    private let suggestionFadeAlphaIn = SKAction.fadeIn(withDuration: 0.25)
    private let suggestionZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private var suggestionAnimation: SKAction?
    
    // delegate
    public weak var gamePaletteDelegate: GamePaletteDelegate?
    
    override public func didMove(to view: SKView) {
        // manage animations
        self.selectionAnimation = SKAction.group([self.selectionZoomIn,
                                                  self.selectionFadeAlpha])
        
        self.deselectionAnimation = SKAction.group([self.deselectionZoomOut,
                                                    self.deselectionFadeAlpha])
        
        self.overlayAnimation = SKAction.group([self.overlayZoomIn,
                                                self.overlayFadeAlpha])
        
        self.notOverlayAnimation = SKAction.group([self.notOverlayZoomOut,
                                                   self.notOverlayFadeAlpha])
        
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
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // get the touch location
            let location = touch.location(in: self)
            
            // get the dot
            self.selectedDot = atPoint(location)
            
            // check if the touch is inside a dot
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
                        if let overlaidDot = self.overlaidDot {
                            if dots.count == 1 {
                                self.animate(dot: overlaidDot, withAnimation: self.notOverlayAnimation)
                                self.overlaidDot = nil
                            }
                        }else if dot != self.selectedDot {
                            self.overlaidDot = dot
                            self.animate(dot: self.overlaidDot, withAnimation: self.overlayAnimation)
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
                    
                    // The user has released a dot over another one, this means he wants to mix them
                    if let overlaidDot = self.overlaidDot {
                        // #1 remove the selected dot
                        self.animate(dot: self.selectedDot, withAnimation: self.removeDotAnimation)
                        // #2 set the new color of the overlaid dot
                        (overlaidDot as! Dot).dotColor.mix(withColor: (self.selectedDot as! Dot).dotColor)
                        // #3 animate the overlaid dot
                        let newColor = (overlaidDot as! Dot).dotColor.toRGBColor()
                        
                        
                        let colorizingDotAnimationColor = SKAction.colorize(with: newColor,
                                                                       colorBlendFactor: 1.0,
                                                                       duration: 0.4)
                        let colorizingDotAnimationFadeIn = SKAction.fadeIn(withDuration: 0.1)
                        let colorizeDotAnimation = SKAction.group([self.colorizingDotAnimationScale!,
                                                                   colorizingDotAnimationColor,
                                                                   colorizingDotAnimationFadeIn])
                        self.animate(dot: overlaidDot, withAnimation: colorizeDotAnimation)
                        
                        // delegate method
                        self.gamePaletteDelegate?.dotDidMove(withNewDot: overlaidDot)
                    }else {
                        self.selectedDot!.zPosition = 0.0
                        let moveToOriginalPosition = SKAction.move(to: (self.selectedDot as! Dot).originalPosition, duration: 0.25)
                        let moveToOriginalPositionAnimation = SKAction.group([self.deselectionAnimation!, moveToOriginalPosition])
                        self.animate(dot: self.selectedDot, withAnimation: moveToOriginalPositionAnimation)
                    }
                    
                    self.touch = nil
                    self.selectedDot = nil
                    self.offset = nil
                    self.overlaidDot = nil
                }
            }
        }
    }
    
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
