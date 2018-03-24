//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

class WelcomeViewController: UIViewController {
    
    var easyGameColorPalette = [RYBColor]()
    var mediumGameColorPalette = [RYBColor]()
    var hardGameColorPalette = [RYBColor]()
    
    let gameDifficulty = DifficultyManager()
    
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
        //TODO: rimuovere da ViewObject il parametro per il colore di sfondo dal momento che viene settato dinamicamente
        easyGameButton.backgroundColor = (self.easyGameColorPalette.last)?.toRGBColor()
        easyGameButton.addTarget(self, action: #selector(WelcomeViewController.easyGameButtonPressed), for: .touchUpInside)
        
        
        let mediumGameButton = UIButton(type: .custom)
        mediumGameButton.setTitle(ViewObject.shared.mediumButton.title, for: .normal)
        mediumGameButton.frame = CGRect(x: ViewObject.shared.mediumButton.x,
                                        y: ViewObject.shared.mediumButton.y,
                                        width: ViewObject.shared.mediumButton.width,
                                        height: ViewObject.shared.mediumButton.height)
        mediumGameButton.layer.cornerRadius = ViewObject.shared.mediumButton.cornerRadius
        mediumGameButton.backgroundColor = ViewObject.shared.mediumButton.color
        mediumGameButton.addTarget(self, action: #selector(WelcomeViewController.mediumGameButtonPressed), for: .touchUpInside)
        
        
        let hardGameButton = UIButton(type: .custom)
        hardGameButton.setTitle(ViewObject.shared.hardButton.title, for: .normal)
        hardGameButton.frame = CGRect(x: ViewObject.shared.hardButton.x,
                                      y: ViewObject.shared.hardButton.y,
                                      width: ViewObject.shared.hardButton.width,
                                      height: ViewObject.shared.hardButton.height)
        hardGameButton.layer.cornerRadius = ViewObject.shared.hardButton.cornerRadius
        hardGameButton.backgroundColor = ViewObject.shared.hardButton.color
        hardGameButton.addTarget(self, action: #selector(WelcomeViewController.hardGameButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(easyGameButton)
        self.view.addSubview(mediumGameButton)
        self.view.addSubview(hardGameButton)
    }
    
    @objc func easyGameButtonPressed() {
        let gameViewController = GameViewController(colorPalette: self.easyGameColorPalette)
        self.present(gameViewController, animated: true, completion: nil)
    }
    
    @objc func mediumGameButtonPressed() {
        let gameViewController = GameViewController(colorPalette: self.mediumGameColorPalette)
        self.present(gameViewController, animated: true, completion: nil)
    }
    
    @objc func hardGameButtonPressed() {
        let gameViewController = GameViewController(colorPalette: self.hardGameColorPalette)
        self.present(gameViewController, animated: true, completion: nil)
    }
    
}

//Playground setup
let welcomeViewController = WelcomeViewController()
PlaygroundPage.current.liveView = welcomeViewController.view
