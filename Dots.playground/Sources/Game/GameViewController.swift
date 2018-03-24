import UIKit
import SpriteKit

public class GameViewController: UIViewController {
    
    var colorPalette: [RYBColor]

    public init(colorPalette: [RYBColor]) {
        self.colorPalette = colorPalette
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        //UIView
        self.view = UIView(frame: CGRect(x: ViewObject.shared.gameView.x,
                                         y: ViewObject.shared.gameView.y,
                                         width: ViewObject.shared.gameView.width,
                                         height: ViewObject.shared.gameView.height))
        self.view.backgroundColor = (self.colorPalette.last)?.toRGBColor()
        
        //SKView
        let paletteView = SKView(frame: CGRect(x: ViewObject.shared.paletteView.x,
                                               y: ViewObject.shared.paletteView.y,
                                               width: ViewObject.shared.paletteView.width,
                                               height: ViewObject.shared.paletteView.height))
        paletteView.ignoresSiblingOrder = true
        paletteView.backgroundColor = ViewObject.shared.paletteView.backgroundColor
        
        //SKScene
        let palette: GamePalette = GamePalette(size: CGSize(width: ViewObject.shared.paletteView.width,
                                                            height: ViewObject.shared.paletteView.height))
        palette.backgroundColor = ViewObject.shared.paletteView.backgroundColor
        self.drawPalette(palette: palette)
        
        paletteView.presentScene(palette)
        
        self.view.addSubview(paletteView)
    }
    
    private func drawPalette(palette: GamePalette){
        
        let xPosition: CGFloat = 80
        let yPosition: CGFloat = 80
        
        let dotCell = (palette.size.width - (xPosition * 2)) / 3
        let marginSpace: CGFloat = 20
        let radius = (dotCell - marginSpace * 2)/2
        
        let xOffset = marginSpace + xPosition + radius
        let yOffset = marginSpace + yPosition + radius
        
        for i in 0 ..< self.colorPalette.count - 1  {
            let dot = Dot(radius: radius,
                          position: CGPoint(x: (dotCell * CGFloat(i % 3)) + xOffset,
                                            y: (dotCell * CGFloat(i / 3)) + yOffset),
                          color: self.colorPalette[i])
            palette.addChild(dot)
        }
        
    }
    
}

