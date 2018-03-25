import SpriteKit

public protocol GamePaletteDelegate: class {
    func dotDidMove(withNewColor color: RYBColor)
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
    private let selectionFadeAlphaIn = SKAction.fadeAlpha(to: 0.8, duration: 0.25)
    private var selectionAnimationIn: SKAction?
    
    private let selectionZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private let selectionFadeAlphaOut = SKAction.fadeIn(withDuration: 0.25)
    private var selectionAnimationOut: SKAction?
    
    private let overlayZoomIn = SKAction.scale(to: 1.3, duration: 0.25)
    private let overlayFadeAlphaIn = SKAction.fadeAlpha(to: 0.6, duration: 0.25)
    private var overlayAnimationIn: SKAction?
    
    private let overlayZoomOut = SKAction.scale(to: 1.0, duration: 0.25)
    private let overlayFadeAlphaOut = SKAction.fadeIn(withDuration: 0.25)
    private var overlayAnimationOut: SKAction?
    
    
    // Mix colors animations
    private let scaleRemovingDot = SKAction.scale(to: 0.0, duration: 0.25)
    private let fadeOutRemovingDot = SKAction.fadeOut(withDuration: 0.25)
    private let removeDot = SKAction.removeFromParent()
    private var removeDotAnimation: SKAction?
    
    private let firstScaleColorizingDot = SKAction.scale(to: 0.8, duration: 0.2)
    private let secondScaleColorizingDot = SKAction.scale(to: 1.1, duration: 0.2)
    private let thirdScaleColorizingDot = SKAction.scale(to: 1.0, duration: 0.2)
    private var scaleColorizingDotAnimation: SKAction?
    
    // delegate
    public weak var gamePaletteDelegate: GamePaletteDelegate?
    
    override public func didMove(to view: SKView) {
        // manage animations
        self.selectionAnimationIn = SKAction.group([self.selectionZoomIn, self.selectionFadeAlphaIn])
        self.selectionAnimationOut = SKAction.group([self.selectionZoomOut, self.selectionFadeAlphaOut])
        self.overlayAnimationIn = SKAction.group([self.overlayZoomIn, self.overlayFadeAlphaIn])
        self.overlayAnimationOut = SKAction.group([self.overlayZoomOut, self.overlayFadeAlphaOut])
        
        let removingDotAnimation = SKAction.group([self.scaleRemovingDot, self.fadeOutRemovingDot])
        self.removeDotAnimation = SKAction.sequence([removingDotAnimation, self.removeDot])
        
        self.scaleColorizingDotAnimation = SKAction.sequence([self.firstScaleColorizingDot, self.secondScaleColorizingDot, self.thirdScaleColorizingDot])
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            // get the touch location
            let location = touch.location(in: self)
            
            // get the dot
            self.selectedDot = atPoint(location)
            
            // check if the touch is inside a dot
            if self.selectedDot!.isKind(of: Dot.self){
                
                self.selectedDot!.run(self.selectionAnimationIn!)
                
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
                                self.animate(dot: overlaidDot, withAnimation: self.overlayAnimationOut)
                                self.overlaidDot = nil
                            }
                        }else if dot != self.selectedDot {
                            self.overlaidDot = dot
                            self.animate(dot: self.overlaidDot, withAnimation: self.overlayAnimationIn)
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
                        let colorizingDotAnimation = SKAction.colorize(with: newColor,
                                                                       colorBlendFactor: 1.0,
                                                                       duration: 0.4)
                        let fadeInColorizingDotAnimation = SKAction.fadeIn(withDuration: 0.1)
                        let colorizeDotAnimation = SKAction.group([self.scaleColorizingDotAnimation!,
                                                                   colorizingDotAnimation,
                                                                   fadeInColorizingDotAnimation])
                        self.animate(dot: overlaidDot, withAnimation: colorizeDotAnimation)
                        
                        self.gamePaletteDelegate?.dotDidMove(withNewColor: (overlaidDot as! Dot).dotColor)
                    }else {
                        self.selectedDot!.zPosition = 0.0
                        let moveToOriginalPosition = SKAction.move(to: (self.selectedDot as! Dot).originalPosition, duration: 0.25)
                        let moveToOriginalPositionAnimation = SKAction.group([self.selectionAnimationOut!, moveToOriginalPosition])
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
