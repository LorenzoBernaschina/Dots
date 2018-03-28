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
        self.view = UIView(frame: CGRect(x: ConstantValues.shared.gameView.x,
                                         y: ConstantValues.shared.gameView.y,
                                         width: ConstantValues.shared.gameView.width,
                                         height: ConstantValues.shared.gameView.height))
        
        let background = UIImageView(frame: CGRect(x: ConstantValues.shared.gameView.x,
                                            y: ConstantValues.shared.gameView.y,
                                            width: ConstantValues.shared.gameView.width,
                                            height: ConstantValues.shared.gameView.height))
        background.image = UIImage(named: "HelpBackground.jpg")
        
        // Dismiss button
        self.dismissButton.setTitle(ConstantValues.shared.dismissButton.title, for: .normal)
        self.dismissButton.setTitleColor(.white, for: .normal)
        self.dismissButton.frame = CGRect(x: ConstantValues.shared.dismissButton.x,
                                          y: ConstantValues.shared.dismissButton.y,
                                          width: ConstantValues.shared.dismissButton.width,
                                          height: ConstantValues.shared.dismissButton.height)
        self.dismissButton.layer.cornerRadius = ConstantValues.shared.dismissButton.cornerRadius
        self.dismissButton.backgroundColor = .black
        self.dismissButton.titleLabel?.font = UIFont(name: ConstantValues.shared.sanFranciscoFont.name, size: 20)
        self.dismissButton.addTarget(self, action: #selector(HelpViewController.dismissViewController(sender:)), for: .touchUpInside)
        
        self.view.addSubview(background)
        self.view.addSubview(self.dismissButton)
    }
    
    @objc func dismissViewController(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

