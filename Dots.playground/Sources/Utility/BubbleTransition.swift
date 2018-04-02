/**
 This class provides a customized circular transition from a modal view to another.
 
 The transition starts and propagates from the center of the button pressed when the view is presented.
 It returns to the same point when the view is dismissed.
 
 Please note: this class is the result of a personal readjustment of an open source class you can find at the following link
 https://github.com/andreamazz/BubbleTransition
*/

import UIKit

public class BubbleTransition: NSObject {
    
    public enum TransitionMode {
        case present
        case dismiss
    }
    
    public var transitionMode: TransitionMode
    
    public var transitionStartingPoint: CGPoint
    
    public var transitionColor: UIColor
    
    private var transitionView: UIView
    
    private var duration: TimeInterval
    
    public init(withDuration duration: TimeInterval){
        self.duration = duration
        
        self.transitionMode = .present
        self.transitionStartingPoint = .zero
        self.transitionColor = .clear
        
        self.transitionView = UIView()
        self.transitionView.center = self.transitionStartingPoint
        self.transitionView.backgroundColor = self.transitionColor
    }
}

extension BubbleTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        switch self.transitionMode {
            case .present:
                if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                    let presentedViewCenter = presentedView.center
                    let presentedViewSize = presentedView.frame.size
                    
                    self.transitionView = UIView()
                    self.transitionView.frame = self.frame(withSize: presentedViewSize, startPoint: self.transitionStartingPoint)
                    self.transitionView.layer.cornerRadius = self.transitionView.frame.size.height / 2
                    self.transitionView.center = self.transitionStartingPoint
                    self.transitionView.backgroundColor = self.transitionColor
                    self.transitionView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    containerView.addSubview(self.transitionView)
                    
                    presentedView.center = self.transitionStartingPoint
                    presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    presentedView.alpha = 0.0
                    containerView.addSubview(presentedView)
                    
                    UIView.animate(withDuration: self.duration, animations: {
                        self.transitionView.transform = CGAffineTransform.identity
                        presentedView.transform = CGAffineTransform.identity
                        presentedView.center = presentedViewCenter
                        presentedView.alpha = 1.0
                    }, completion: { (success: Bool) in
                        transitionContext.completeTransition(success)
                    })
                }
            
            case .dismiss:
                if let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
                    let dismissedViewCenter = dismissedView.center
                    let dismissedViewSize = dismissedView.frame.size
                    
                    self.transitionView.frame = self.frame(withSize: dismissedViewSize, startPoint: self.transitionStartingPoint)
                    self.transitionView.layer.cornerRadius = self.transitionView.frame.size.height / 2
                    self.transitionView.center = self.transitionStartingPoint
                    
                    UIView.animate(withDuration: self.duration, animations: {
                        self.transitionView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        dismissedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        dismissedView.center = self.transitionStartingPoint
                        dismissedView.alpha = 0.0
                    }, completion: { (success: Bool) in
                        dismissedView.center = dismissedViewCenter
                        dismissedView.removeFromSuperview()
                        self.transitionView.removeFromSuperview()
                        transitionContext.completeTransition(success)
                    })
                }
        }
    }
    
    private func frame(withSize viewSize:CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}

