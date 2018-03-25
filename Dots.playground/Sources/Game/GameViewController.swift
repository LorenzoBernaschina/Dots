import UIKit
import SpriteKit

public class GameViewController: UIViewController {
    
    private var colorPalette = [RYBColor]()
    
    private let goalColor: RYBColor?
    
    private var palette: GamePalette?
    
    private let circularTransition = CircularTransition(withDuration: 0.4)
    
    private let dismissButton = UIButton(type: .custom)
    private let helpButton = UIButton(type: .custom)

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
        self.dismissButton.setTitle(ViewObject.shared.dismissButton.title, for: .normal)
        self.dismissButton.setTitleColor(self.goalColor!.toRGBColor(), for: .normal)
        self.dismissButton.frame = CGRect(x: ViewObject.shared.dismissButton.x,
                                      y: ViewObject.shared.dismissButton.y,
                                      width: ViewObject.shared.dismissButton.width,
                                      height: ViewObject.shared.dismissButton.height)
        self.dismissButton.layer.cornerRadius = ViewObject.shared.dismissButton.cornerRadius
        self.dismissButton.backgroundColor = .white
        self.dismissButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 20)
        self.dismissButton.addTarget(self, action: #selector(GameViewController.dismissViewController(sender:)), for: .touchUpInside)
        
        // Help button
        self.helpButton.setTitle(ViewObject.shared.helpButton.title, for: .normal)
        self.helpButton.setTitleColor(self.goalColor!.toRGBColor(), for: .normal)
        self.helpButton.frame = CGRect(x: ViewObject.shared.helpButton.x,
                                     y: ViewObject.shared.helpButton.y,
                                     width: ViewObject.shared.helpButton.width,
                                     height: ViewObject.shared.helpButton.height)
        self.helpButton.layer.cornerRadius = ViewObject.shared.helpButton.cornerRadius
        self.helpButton.backgroundColor = .white
        self.helpButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 20)
        self.helpButton.addTarget(self, action: #selector(GameViewController.showHelp(sender:)), for: .touchUpInside)
        
        
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
        self.view.addSubview(helpButton)
 
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
    
    @objc func showHelp(sender: UIButton) {
        let helpViewController = HelpViewController()
        helpViewController.transitioningDelegate = self
        helpViewController.modalPresentationStyle = .custom
        self.present(helpViewController, animated: true, completion: nil)
    }
 
}

extension GameViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.circularTransition.transitionMode = .present
        self.circularTransition.transitionStartingPoint = self.helpButton.center
        self.circularTransition.transitionColor = self.helpButton.backgroundColor!
        
        return self.circularTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.circularTransition.transitionMode = .dismiss
        self.circularTransition.transitionStartingPoint = self.helpButton.center
        self.circularTransition.transitionColor = self.helpButton.backgroundColor!
        
        return self.circularTransition
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

