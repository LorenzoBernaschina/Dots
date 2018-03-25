//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class WelcomeViewController: UIViewController {
    
    private let circularTransition = CircularTransition(withDuration: 0.4)
    private var currentButtonPressed = UIButton()
    
    private var easyGameColorPalette = [RYBColor]()
    private var mediumGameColorPalette = [RYBColor]()
    private var hardGameColorPalette = [RYBColor]()
    
    private let gameDifficulty = DifficultyManager()
    
    private let easyGameButton = UIButton(type: .custom)
    private let mediumGameButton = UIButton(type: .custom)
    private let hardGameButton = UIButton(type: .custom)
    
    private let resetGameButton = UIButton(type: .custom)
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.setGameColorPalette()
        
        self.view = UIView(frame: CGRect(x: ViewObject.shared.gameView.x,
                                         y: ViewObject.shared.gameView.y,
                                         width: ViewObject.shared.gameView.width,
                                         height: ViewObject.shared.gameView.height))
        self.view.backgroundColor = ViewObject.shared.gameView.backgroundColor
        
        
        self.easyGameButton.setTitle(ViewObject.shared.easyButton.title, for: .normal)
        self.easyGameButton.frame = CGRect(x: ViewObject.shared.easyButton.x,
                                      y: ViewObject.shared.easyButton.y,
                                      width: ViewObject.shared.easyButton.width,
                                      height: ViewObject.shared.easyButton.height)
        self.easyGameButton.layer.cornerRadius = ViewObject.shared.easyButton.cornerRadius
        self.easyGameButton.backgroundColor = (self.easyGameColorPalette.last)?.toRGBColor()
        self.easyGameButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 50)
        self.easyGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        self.easyGameButton.jumpAnimation(withDuration: 2.0, damping: 0.4, initialVelocity: 4.0)
        
        
        self.mediumGameButton.setTitle(ViewObject.shared.mediumButton.title, for: .normal)
        self.mediumGameButton.frame = CGRect(x: ViewObject.shared.mediumButton.x,
                                        y: ViewObject.shared.mediumButton.y,
                                        width: ViewObject.shared.mediumButton.width,
                                        height: ViewObject.shared.mediumButton.height)
        self.mediumGameButton.layer.cornerRadius = ViewObject.shared.mediumButton.cornerRadius
        self.mediumGameButton.backgroundColor = (self.mediumGameColorPalette.last)?.toRGBColor()
        self.mediumGameButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 30)
        self.mediumGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        self.mediumGameButton.jumpAnimation(withDuration: 2.0, damping: 0.3, initialVelocity: 4.0)
        
    
        self.hardGameButton.setTitle(ViewObject.shared.hardButton.title, for: .normal)
        self.hardGameButton.frame = CGRect(x: ViewObject.shared.hardButton.x,
                                      y: ViewObject.shared.hardButton.y,
                                      width: ViewObject.shared.hardButton.width,
                                      height: ViewObject.shared.hardButton.height)
        self.hardGameButton.layer.cornerRadius = ViewObject.shared.hardButton.cornerRadius
        self.hardGameButton.backgroundColor = (self.hardGameColorPalette.last)?.toRGBColor()
        self.hardGameButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 25)
        self.hardGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        self.hardGameButton.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
        
        
        self.resetGameButton.setTitle(ViewObject.shared.resetButton.title, for: .normal)
        self.resetGameButton.frame = CGRect(x: ViewObject.shared.resetButton.x,
                                            y: ViewObject.shared.resetButton.y,
                                            width: ViewObject.shared.resetButton.width,
                                            height: ViewObject.shared.resetButton.height)
        self.resetGameButton.layer.cornerRadius = ViewObject.shared.resetButton.cornerRadius
        self.resetGameButton.backgroundColor = .black
        self.resetGameButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 25)
        self.resetGameButton.addTarget(self, action: #selector(WelcomeViewController.resetGame(sender:)), for: .touchUpInside)
        self.resetGameButton.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
        
        self.view.addSubview(self.easyGameButton)
        self.view.addSubview(self.mediumGameButton)
        self.view.addSubview(self.hardGameButton)
        self.view.addSubview(self.resetGameButton)
    }
    
    @objc func resetGame(sender: UIButton) {
        self.setGameColorPalette()
        self.resetButtons()
    }
    
    private func setGameColorPalette() {
        self.easyGameColorPalette = self.gameDifficulty.setGameColorPalette(withDifficultyLevel: Easy())
        self.mediumGameColorPalette = self.gameDifficulty.setGameColorPalette(withDifficultyLevel: Medium())
        self.hardGameColorPalette = self.gameDifficulty.setGameColorPalette(withDifficultyLevel: Hard())
    }
    
    private func resetButtons() {
        self.easyGameButton.backgroundColor = (self.easyGameColorPalette.last)?.toRGBColor()
        self.mediumGameButton.backgroundColor = (self.mediumGameColorPalette.last)?.toRGBColor()
        self.hardGameButton.backgroundColor = (self.hardGameColorPalette.last)?.toRGBColor()
        
        self.easyGameButton.jumpAnimation(withDuration: 2.0, damping: 0.4, initialVelocity: 4.0)
        self.mediumGameButton.jumpAnimation(withDuration: 2.0, damping: 0.3, initialVelocity: 4.0)
        self.hardGameButton.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
    }

    @objc func buttonPressed(sender: UIButton) {
        var gameViewController: GameViewController?
        
        if let buttonTitle = sender.titleLabel?.text{
            switch buttonTitle {
            case ViewObject.shared.easyButton.title:
                gameViewController = GameViewController(colorPalette: self.easyGameColorPalette)
            case ViewObject.shared.mediumButton.title:
                gameViewController = GameViewController(colorPalette: self.mediumGameColorPalette)
            case ViewObject.shared.hardButton.title:
                gameViewController = GameViewController(colorPalette: self.hardGameColorPalette)
            default:
                break
            }
        }
        
        if let viewController = gameViewController {
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = .custom
            
            self.circularTransition.transitionMode = .present
            self.circularTransition.transitionStartingPoint = sender.center
            self.circularTransition.transitionColor = sender.backgroundColor!
            
            self.currentButtonPressed = sender
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension WelcomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self.circularTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.circularTransition.transitionMode = .dismiss
        self.circularTransition.transitionStartingPoint = self.currentButtonPressed.center
        self.circularTransition.transitionColor = self.currentButtonPressed.backgroundColor!
        
        self.currentButtonPressed.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
        
        return self.circularTransition
    }
}

extension UIButton {
    public func jumpAnimation(withDuration duration: TimeInterval, damping: CGFloat, initialVelocity: CGFloat) {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialVelocity,
                       options: .allowUserInteraction,
                       animations: {[weak self] in self?.transform = .identity},
                       completion: nil)
    }
}

//Playground setup
let welcomeViewController = WelcomeViewController()
PlaygroundPage.current.liveView = welcomeViewController.view
