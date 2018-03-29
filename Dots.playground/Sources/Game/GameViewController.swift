import UIKit
import SpriteKit

public enum GameStatus {
    case Won
    case Lost
}

public protocol GameViewControllerDelegate: class {
    /**
     Called every time the game ends.
     Use this method to check the outcome of the game and to provide a message to the user.
     
     - parameters:
     - status: the state with which the game is finished. It can be .Won or .Lost
    */
    func gameEnded(withStatus status: GameStatus)
}

public class GameViewController: UIViewController {
    
    private var colorPalette = [RYBColor]()
    
    private var suggestionPalette = [RYBColor]()
    
    private let goalColor: RYBColor?
    
    private var palette: GamePalette?
    
    private let circularTransition = CircularTransition(withDuration: 0.4)
    
    private let dismissButton = UIButton(type: .custom)
    
    private let helpButton = UIButton(type: .custom)
    
    private var suggestionTimer: Timer?
    private let suggestionTime: TimeInterval = 10.0
    
    public weak var gameViewControllerDelegate: GameViewControllerDelegate?
    
    public init(colorPalette: [RYBColor]) {
        for i in 0 ..< colorPalette.count {
            let color = RYBColor(red: colorPalette[i].red, yellow: colorPalette[i].yellow, blue: colorPalette[i].blue)
            
            if i < 9 || i == colorPalette.count - 1 {
                self.colorPalette.append(color)
            }else {
                self.suggestionPalette.append(color)
            }
        }
        
        self.goalColor = self.colorPalette.last
        
        self.palette = GamePalette(size: CGSize(width: ConstantValues.shared.paletteView.width,
                                                height: ConstantValues.shared.paletteView.height))

        super.init(nibName: nil, bundle: nil)
    
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func loadView() {
        //UIView
        self.view = UIView(frame: CGRect(x: ConstantValues.shared.gameView.x,
                                         y: ConstantValues.shared.gameView.y,
                                         width: ConstantValues.shared.gameView.width,
                                         height: ConstantValues.shared.gameView.height))
        self.view.backgroundColor = (self.colorPalette.last)?.toRGBColor()
        
        // Dismiss button
        self.dismissButton.setTitle(ConstantValues.shared.dismissButton.title, for: .normal)
        self.dismissButton.setTitleColor(self.goalColor!.toRGBColor(), for: .normal)
        self.dismissButton.frame = CGRect(x: ConstantValues.shared.dismissButton.x,
                                      y: ConstantValues.shared.dismissButton.y,
                                      width: ConstantValues.shared.dismissButton.width,
                                      height: ConstantValues.shared.dismissButton.height)
        self.dismissButton.layer.cornerRadius = ConstantValues.shared.dismissButton.cornerRadius
        self.dismissButton.backgroundColor = .white
        self.dismissButton.titleLabel?.font = UIFont(name: ConstantValues.shared.sanFranciscoFont.name, size: 20)
        self.dismissButton.addTarget(self, action: #selector(GameViewController.dismissViewController(sender:)), for: .touchUpInside)
        
        // Help button
        self.helpButton.setTitle(ConstantValues.shared.helpButton.title, for: .normal)
        self.helpButton.setTitleColor(self.goalColor!.toRGBColor(), for: .normal)
        self.helpButton.frame = CGRect(x: ConstantValues.shared.helpButton.x,
                                     y: ConstantValues.shared.helpButton.y,
                                     width: ConstantValues.shared.helpButton.width,
                                     height: ConstantValues.shared.helpButton.height)
        self.helpButton.layer.cornerRadius = ConstantValues.shared.helpButton.cornerRadius
        self.helpButton.backgroundColor = .white
        self.helpButton.titleLabel?.font = UIFont(name: ConstantValues.shared.sanFranciscoFont.name, size: 20)
        self.helpButton.addTarget(self, action: #selector(GameViewController.showHelp(sender:)), for: .touchUpInside)
        
        
        //SKView
        let paletteView = SKView(frame: CGRect(x: ConstantValues.shared.paletteView.x,
                                               y: ConstantValues.shared.paletteView.y,
                                               width: ConstantValues.shared.paletteView.width,
                                               height: ConstantValues.shared.paletteView.height))
        paletteView.ignoresSiblingOrder = true
        paletteView.backgroundColor = ConstantValues.shared.paletteView.backgroundColor
        
        //SKScene
        if let palette = self.palette {
            palette.gamePaletteDelegate = self
            palette.backgroundColor = ConstantValues.shared.paletteView.backgroundColor
            self.drawPalette(palette: palette)
        
            paletteView.presentScene(palette)
        }
        
        self.view.addSubview(paletteView)
        self.view.addSubview(dismissButton)
        self.view.addSubview(helpButton)
        
        // set the event suggestion
        self.suggestionTimer = Timer.scheduledTimer(timeInterval: self.suggestionTime,
                                                    target: self,
                                                    selector: #selector(GameViewController.showSuggestion(sender:)),
                                                    userInfo: nil,
                                                    repeats: true)
    }
    
    @objc func showSuggestion(sender: Timer) {
        if (self.suggestionPalette.count > 1) {
            // if the user is not on the right path, don't provide suggestions anymore
            if !self.palette!.nextMoveSuggestion(forColor: self.suggestionPalette[0], and: self.suggestionPalette[1]) {
                self.stopTimer()
            }
        }else {
            self.stopTimer()
        }
    }
    
    private func drawPalette(palette: GamePalette){
        let xPosition: CGFloat = 80
        let yPosition: CGFloat = 80
        
        let dotCell = (palette.size.width - (xPosition * 2)) / 3
        let marginSpace: CGFloat = 20
        let radius = (dotCell - marginSpace * 2)/2
        
        let xOffset = marginSpace + xPosition + radius
        let yOffset = marginSpace + yPosition + radius
        
        for i in 0 ..< 9  {
            let dot = Dot(radius: radius,
                          position: CGPoint(x: (dotCell * CGFloat(i % 3)) + xOffset,
                                            y: (dotCell * CGFloat(i / 3)) + yOffset),
                          color: self.colorPalette[i])
            palette.addChild(dot)
        }
    }
    
    private func resetTimer() {
        if let suggestionTimer = self.suggestionTimer {
            if suggestionTimer.isValid {
                suggestionTimer.fireDate = Date(timeIntervalSinceNow: self.suggestionTime)
            }
        }
    }
    
    private func stopTimer() {
        if let suggestionTimer = self.suggestionTimer {
            if suggestionTimer.isValid {
                suggestionTimer.invalidate()
            }
        }
    }
    
    @objc func showHelp(sender: UIButton) {
        let helpViewController = HelpViewController()
        helpViewController.transitioningDelegate = self
        helpViewController.modalPresentationStyle = .custom
        self.present(helpViewController, animated: true, completion: nil)
    }
    
    @objc func dismissViewController(sender: UIButton) {
        self.stopTimer()
        self.dismiss(animated: true, completion: nil)
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
    public func dotDidMove(withNewDot dot: SKNode) {
        let color = (dot as! Dot).dotColor
        
        // check if goal color is reached
        if let goalColor = self.goalColor {
            if (color.red == goalColor.red && color.yellow == goalColor.yellow && color.blue == goalColor.blue){
                self.stopTimer()
                self.dismiss(animated: true, completion: {
                    self.gameViewControllerDelegate?.gameEnded(withStatus: .Won)
                })
            }else if (self.palette!.children.count - 1 == 1) {
                self.stopTimer()
                self.dismiss(animated: true, completion: {
                    self.gameViewControllerDelegate?.gameEnded(withStatus: .Lost)
                })
            }
        }
        
        // check if the user is still on the right path to get the solution, then update the suggestionPalette and reset the timer to provide the next suggestion
        if (self.suggestionPalette.count > 1 && self.suggestionTimer!.isValid) {
            self.suggestionPalette[0].mix(withColor: self.suggestionPalette[1])
            if (color.red == self.suggestionPalette[0].red && color.yellow == self.suggestionPalette[0].yellow && color.blue == self.suggestionPalette[0].blue) {
                self.suggestionPalette.remove(at: 1)
                self.resetTimer()
            }
        }
    }
}

