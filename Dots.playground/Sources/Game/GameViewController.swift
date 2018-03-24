import UIKit
import SpriteKit

public class GameViewController: UIViewController {
    
    private var colorPalette = [RYBColor]()
    
    private let goalColor: RYBColor?
    
    private var palette: GamePalette?

    public init(colorPalette: [RYBColor]) {
        
        for i in 0 ..< colorPalette.count {
            let color = RYBColor(red: colorPalette[i].red, yellow: colorPalette[i].yellow, blue: colorPalette[i].blue)
            self.colorPalette.append(color)
        }
        
        self.goalColor = self.colorPalette.last
        
        self.palette = GamePalette(size: CGSize(width: ViewObject.shared.paletteView.width,
                                                height: ViewObject.shared.paletteView.height))
        
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
        
        // Dismiss button
        let dismissButton = UIButton(type: .custom)
        dismissButton.setTitle(ViewObject.shared.dismissButton.title, for: .normal)
        dismissButton.setTitleColor(self.goalColor!.toRGBColor(), for: .normal)
        dismissButton.frame = CGRect(x: ViewObject.shared.dismissButton.x,
                                      y: ViewObject.shared.dismissButton.y,
                                      width: ViewObject.shared.dismissButton.width,
                                      height: ViewObject.shared.dismissButton.height)
        dismissButton.layer.cornerRadius = ViewObject.shared.dismissButton.cornerRadius
        dismissButton.backgroundColor = .white
        dismissButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 20)
        
        dismissButton.addTarget(self, action: #selector(GameViewController.dismissViewController(sender:)), for: .touchUpInside)
        
        //SKView
        let paletteView = SKView(frame: CGRect(x: ViewObject.shared.paletteView.x,
                                               y: ViewObject.shared.paletteView.y,
                                               width: ViewObject.shared.paletteView.width,
                                               height: ViewObject.shared.paletteView.height))
        paletteView.ignoresSiblingOrder = true
        paletteView.backgroundColor = ViewObject.shared.paletteView.backgroundColor
        
        //SKScene
        if let palette = self.palette {
            palette.gamePaletteDelegate = self
            palette.backgroundColor = ViewObject.shared.paletteView.backgroundColor
            self.drawPalette(palette: palette)
        
            paletteView.presentScene(palette)
        }
        
        self.view.addSubview(paletteView)
        self.view.addSubview(dismissButton)
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
    
    @objc func dismissViewController(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GameViewController: GamePaletteDelegate {
    public func dotDidMove(withNewColor color: RYBColor) {
        if let goalColor = self.goalColor {
            if (color.red == goalColor.red && color.yellow == goalColor.yellow && color.blue == goalColor.blue){
                print("you won!!!")
            }else if (self.palette!.children.count - 1 == 1) {
                print("you lose")
            }
        }
    }
}

