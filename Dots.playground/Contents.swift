//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class WelcomeViewController: UIViewController {
    
    private let circularTransition = CircularTransition(withDuration: 0.4)
    private var currentTransitionStartingPoint: CGPoint = .zero
    private var currentTransitionColor: UIColor = .clear
    
    private var easyGameColorPalette = [RYBColor]()
    private var mediumGameColorPalette = [RYBColor]()
    private var hardGameColorPalette = [RYBColor]()
    
    private let gameDifficulty = DifficultyManager()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.easyGameColorPalette = self.gameDifficulty.setGameColorPalette(withDifficultyLevel: Easy())
        self.mediumGameColorPalette = self.gameDifficulty.setGameColorPalette(withDifficultyLevel: Medium())
        self.hardGameColorPalette = self.gameDifficulty.setGameColorPalette(withDifficultyLevel: Hard())
        
        self.view = UIView(frame: CGRect(x: ViewObject.shared.gameView.x,
                                         y: ViewObject.shared.gameView.y,
                                         width: ViewObject.shared.gameView.width,
                                         height: ViewObject.shared.gameView.height))
        
        self.view.backgroundColor = ViewObject.shared.gameView.backgroundColor
        
        let easyGameButton = UIButton(type: .custom)
        easyGameButton.setTitle(ViewObject.shared.easyButton.title, for: .normal)
        easyGameButton.frame = CGRect(x: ViewObject.shared.easyButton.x,
                                      y: ViewObject.shared.easyButton.y,
                                      width: ViewObject.shared.easyButton.width,
                                      height: ViewObject.shared.easyButton.height)
        easyGameButton.layer.cornerRadius = ViewObject.shared.easyButton.cornerRadius
        easyGameButton.backgroundColor = (self.easyGameColorPalette.last)?.toRGBColor()
        easyGameButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 50)
        easyGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        
        
        let mediumGameButton = UIButton(type: .custom)
        mediumGameButton.setTitle(ViewObject.shared.mediumButton.title, for: .normal)
        mediumGameButton.frame = CGRect(x: ViewObject.shared.mediumButton.x,
                                        y: ViewObject.shared.mediumButton.y,
                                        width: ViewObject.shared.mediumButton.width,
                                        height: ViewObject.shared.mediumButton.height)
        mediumGameButton.layer.cornerRadius = ViewObject.shared.mediumButton.cornerRadius
        mediumGameButton.backgroundColor = (self.mediumGameColorPalette.last)?.toRGBColor()
        mediumGameButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 30)
        mediumGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        
        
        let hardGameButton = UIButton(type: .custom)
        hardGameButton.setTitle(ViewObject.shared.hardButton.title, for: .normal)
        hardGameButton.frame = CGRect(x: ViewObject.shared.hardButton.x,
                                      y: ViewObject.shared.hardButton.y,
                                      width: ViewObject.shared.hardButton.width,
                                      height: ViewObject.shared.hardButton.height)
        hardGameButton.layer.cornerRadius = ViewObject.shared.hardButton.cornerRadius
        hardGameButton.backgroundColor = (self.hardGameColorPalette.last)?.toRGBColor()
        hardGameButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 25)
        hardGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        
        self.view.addSubview(easyGameButton)
        self.view.addSubview(mediumGameButton)
        self.view.addSubview(hardGameButton)
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
            
            self.currentTransitionStartingPoint = self.circularTransition.transitionStartingPoint
            self.currentTransitionColor = self.circularTransition.transitionColor
            
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
        self.circularTransition.transitionStartingPoint = self.currentTransitionStartingPoint
        self.circularTransition.transitionColor = self.currentTransitionColor
        
        return self.circularTransition
    }
}

//Playground setup
let welcomeViewController = WelcomeViewController()
PlaygroundPage.current.liveView = welcomeViewController.view
