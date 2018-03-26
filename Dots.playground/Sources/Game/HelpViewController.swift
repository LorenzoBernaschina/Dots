import UIKit

public class HelpViewController: UIViewController {
    
    private let dismissButton = UIButton(type: .custom)
    
    public init() {
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
        
        let background = UIImageView(frame: CGRect(x: ViewObject.shared.gameView.x,
                                            y: ViewObject.shared.gameView.y,
                                            width: ViewObject.shared.gameView.width,
                                            height: ViewObject.shared.gameView.height))
        background.image = UIImage(named: "HelpBackground.jpg")
        
        // Dismiss button
        self.dismissButton.setTitle(ViewObject.shared.dismissButton.title, for: .normal)
        self.dismissButton.setTitleColor(.white, for: .normal)
        self.dismissButton.frame = CGRect(x: ViewObject.shared.dismissButton.x,
                                          y: ViewObject.shared.dismissButton.y,
                                          width: ViewObject.shared.dismissButton.width,
                                          height: ViewObject.shared.dismissButton.height)
        self.dismissButton.layer.cornerRadius = ViewObject.shared.dismissButton.cornerRadius
        self.dismissButton.backgroundColor = .black
        self.dismissButton.titleLabel?.font = UIFont(name: ViewObject.shared.sanFranciscoFont.name, size: 20)
        self.dismissButton.addTarget(self, action: #selector(HelpViewController.dismissViewController(sender:)), for: .touchUpInside)
        
        self.view.addSubview(background)
        self.view.addSubview(self.dismissButton)
    }
    
    @objc func dismissViewController(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

