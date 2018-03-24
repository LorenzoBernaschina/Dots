import SpriteKit
import UIKit

public class Dot: SKSpriteNode {
    
    private var radius: CGFloat
    
    public var originalPosition: CGPoint
    
    public var dotColor: RYBColor {
        didSet{
            self.color = dotColor.toRGBColor()
        }
    }
    
    init(radius: CGFloat, position: CGPoint, color: RYBColor){
        
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = .white
        
        self.radius = radius
        self.originalPosition = position
        self.dotColor = color
    
        super.init(texture: SKView().texture(from: circle),
                   color: color.toRGBColor(),
                   size: CGSize(width: radius * 2, height: radius * 2))
        
        self.position = position
        self.color = color.toRGBColor()
        
        self.colorBlendFactor = 1.0
        self.zPosition = 0.0
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

