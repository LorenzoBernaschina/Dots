//: ![](Cover.pdf)

import UIKit
import AVFoundation
import PlaygroundSupport

class WelcomeViewController: UIViewController {
    
    private let bubbleTransition = BubbleTransition(withDuration: 0.4)
    private var currentButtonPressed = UIButton()
    
    private var easyGameColorPalette = [RYBColor]()
    private var mediumGameColorPalette = [RYBColor]()
    private var hardGameColorPalette = [RYBColor]()
    
    private let gameDifficulty = DifficultyManager()
    
    private let easyGameButton = UIButton(type: .custom)
    private let mediumGameButton = UIButton(type: .custom)
    private let hardGameButton = UIButton(type: .custom)
    
    private let resetGameButton = UIButton(type: .custom)
    
    private var soundtrack: AVAudioPlayer!
    
    public init() {
        let soundFilePath = Bundle.main.path(forResource: ConstantValues.shared.welcomeSoundtrack.name,
                                             ofType: ConstantValues.shared.welcomeSoundtrack.type)
        let soundFileURL = URL(fileURLWithPath: soundFilePath!)
        do{
            self.soundtrack = try AVAudioPlayer(contentsOf: soundFileURL)
            self.soundtrack.volume = 0.6
            self.soundtrack.numberOfLoops = -1 //Infinite Loop 
            self.soundtrack.play()
        } catch {
            print("\(error)")
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.setGame()
        
        self.view = UIView(frame: CGRect(x: ConstantValues.shared.gameView.x,
                                         y: ConstantValues.shared.gameView.y,
                                         width: ConstantValues.shared.gameView.width,
                                         height: ConstantValues.shared.gameView.height))
        
        let background = UIImageView(frame: CGRect(x: ConstantValues.shared.welcomeBackgroundImage.x,
                                                   y: ConstantValues.shared.welcomeBackgroundImage.y,
                                                   width: ConstantValues.shared.welcomeBackgroundImage.width,
                                                   height: ConstantValues.shared.welcomeBackgroundImage.height))
        background.image = UIImage(named: ConstantValues.shared.welcomeBackgroundImage.name)
        
        self.easyGameButton.setTitle(ConstantValues.shared.easyButton.title, for: .normal)
        self.easyGameButton.tag = 0
        self.easyGameButton.frame = CGRect(x: ConstantValues.shared.easyButton.x,
                                      y: ConstantValues.shared.easyButton.y,
                                      width: ConstantValues.shared.easyButton.width,
                                      height: ConstantValues.shared.easyButton.height)
        self.easyGameButton.titleLabel?.textAlignment = .center
        self.easyGameButton.layer.cornerRadius = ConstantValues.shared.easyButton.cornerRadius
        self.easyGameButton.backgroundColor = (self.easyGameColorPalette.last)?.toRGBColor()
        self.easyGameButton.titleLabel?.font = UIFont(name: ConstantValues.shared.sanFranciscoFont.name, size: 50)
        self.easyGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        self.easyGameButton.jumpAnimation(withDuration: 2.0, damping: 0.4, initialVelocity: 4.0)
        
        
        self.mediumGameButton.setTitle(ConstantValues.shared.mediumButton.title, for: .normal)
        self.mediumGameButton.tag = 1
        self.mediumGameButton.frame = CGRect(x: ConstantValues.shared.mediumButton.x,
                                        y: ConstantValues.shared.mediumButton.y,
                                        width: ConstantValues.shared.mediumButton.width,
                                        height: ConstantValues.shared.mediumButton.height)
        self.mediumGameButton.titleLabel?.textAlignment = .center
        self.mediumGameButton.layer.cornerRadius = ConstantValues.shared.mediumButton.cornerRadius
        self.mediumGameButton.backgroundColor = (self.mediumGameColorPalette.last)?.toRGBColor()
        self.mediumGameButton.titleLabel?.font = UIFont(name: ConstantValues.shared.sanFranciscoFont.name, size: 30)
        self.mediumGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        self.mediumGameButton.jumpAnimation(withDuration: 2.0, damping: 0.3, initialVelocity: 4.0)
        
    
        self.hardGameButton.setTitle(ConstantValues.shared.hardButton.title, for: .normal)
        self.hardGameButton.tag = 2
        self.hardGameButton.frame = CGRect(x: ConstantValues.shared.hardButton.x,
                                      y: ConstantValues.shared.hardButton.y,
                                      width: ConstantValues.shared.hardButton.width,
                                      height: ConstantValues.shared.hardButton.height)
        self.hardGameButton.titleLabel?.textAlignment = .center
        self.hardGameButton.layer.cornerRadius = ConstantValues.shared.hardButton.cornerRadius
        self.hardGameButton.backgroundColor = (self.hardGameColorPalette.last)?.toRGBColor()
        self.hardGameButton.titleLabel?.font = UIFont(name: ConstantValues.shared.sanFranciscoFont.name, size: 25)
        self.hardGameButton.addTarget(self, action: #selector(WelcomeViewController.buttonPressed(sender:)), for: .touchUpInside)
        self.hardGameButton.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
        
        
        self.resetGameButton.setImage(UIImage(named: ConstantValues.shared.resetButton.title), for: .normal)
        self.resetGameButton.frame = CGRect(x: ConstantValues.shared.resetButton.x,
                                            y: ConstantValues.shared.resetButton.y,
                                            width: ConstantValues.shared.resetButton.width,
                                            height: ConstantValues.shared.resetButton.height)
        self.resetGameButton.layer.cornerRadius = ConstantValues.shared.resetButton.cornerRadius
        self.resetGameButton.backgroundColor = .black
        self.resetGameButton.titleLabel?.font = UIFont(name: ConstantValues.shared.sanFranciscoFont.name, size: 25)
        self.resetGameButton.addTarget(self, action: #selector(WelcomeViewController.resetGame(sender:)), for: .touchUpInside)
        self.resetGameButton.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
        
        self.view.addSubview(background)
        self.view.addSubview(self.easyGameButton)
        self.view.addSubview(self.mediumGameButton)
        self.view.addSubview(self.hardGameButton)
        self.view.addSubview(self.resetGameButton)
    }
    
    @objc func resetGame(sender: UIButton) {
        self.setGame()
        self.setButtons()
    }
    
    private func setGame() {
        self.easyGameColorPalette = self.gameDifficulty.setGame(withDifficultyLevel: Easy())
        self.mediumGameColorPalette = self.gameDifficulty.setGame(withDifficultyLevel: Medium())
        self.hardGameColorPalette = self.gameDifficulty.setGame(withDifficultyLevel: Hard())
    }
    
    private func setButtons() {
        self.easyGameButton.setTitle(ConstantValues.shared.easyButton.title, for: .normal)
        self.mediumGameButton.setTitle(ConstantValues.shared.mediumButton.title, for: .normal)
        self.hardGameButton.setTitle(ConstantValues.shared.hardButton.title, for: .normal)
        
        self.easyGameButton.backgroundColor = (self.easyGameColorPalette.last)?.toRGBColor()
        self.mediumGameButton.backgroundColor = (self.mediumGameColorPalette.last)?.toRGBColor()
        self.hardGameButton.backgroundColor = (self.hardGameColorPalette.last)?.toRGBColor()
        
        self.easyGameButton.jumpAnimation(withDuration: 2.0, damping: 0.4, initialVelocity: 4.0)
        self.mediumGameButton.jumpAnimation(withDuration: 2.0, damping: 0.3, initialVelocity: 4.0)
        self.hardGameButton.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
    }

    @objc func buttonPressed(sender: UIButton) {
        var gameViewController: GameViewController?
        
        switch sender.tag {
        case 0:
            gameViewController = GameViewController(colorPalette: self.easyGameColorPalette, level: .Easy)
        case 1:
            gameViewController = GameViewController(colorPalette: self.mediumGameColorPalette, level: .Medium)
        case 2:
            gameViewController = GameViewController(colorPalette: self.hardGameColorPalette, level: .Hard)
        default:
            break
            
        }
        
        if let viewController = gameViewController {
            viewController.gameViewControllerDelegate = self
            viewController.transitioningDelegate = self
            viewController.modalPresentationStyle = .custom
            
            self.bubbleTransition.transitionMode = .present
            self.bubbleTransition.transitionStartingPoint = sender.center
            self.bubbleTransition.transitionColor = sender.backgroundColor!
            
            self.currentButtonPressed = sender
            
            self.soundtrack.pause()
            
            self.present(viewController, animated: true, completion: nil)
        }
    }

}

extension WelcomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self.bubbleTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.bubbleTransition.transitionMode = .dismiss
        self.bubbleTransition.transitionStartingPoint = self.currentButtonPressed.center
        self.bubbleTransition.transitionColor = self.currentButtonPressed.backgroundColor!
        
        self.currentButtonPressed.jumpAnimation(withDuration: 2.0, damping: 0.2, initialVelocity: 4.0)
        
        return self.bubbleTransition
    }
}

extension WelcomeViewController: GameViewControllerDelegate {
    
    public func gameEnded(withStatus status: GameStatus) {
        self.currentButtonPressed.titleLabel?.adjustsFontSizeToFitWidth = true
        self.currentButtonPressed.titleLabel?.minimumScaleFactor = 0.5
        self.currentButtonPressed.titleLabel?.numberOfLines = 1
        switch status {
        case .Won:
            self.currentButtonPressed.setTitle("You won!", for: .normal)
        case .Lost:
            self.currentButtonPressed.setTitle("Try again", for: .normal)
        case .Interrupted:
            break
        }
        
        self.soundtrack.play()
    }
}

extension UIView {
    public func jumpAnimation(withDuration duration: TimeInterval, damping: CGFloat, initialVelocity: CGFloat) {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: initialVelocity,
                       options: .allowUserInteraction,
                       animations: { [weak self] in self?.transform = .identity },
                       completion: nil)
    }
}

let welcomeViewController = WelcomeViewController()
PlaygroundPage.current.liveView = welcomeViewController.view
