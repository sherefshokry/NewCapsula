//
//  CircularTransition.swift
//  Capsula
//
//  Created by SherifShokry on 4/3/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//


import UIKit

class CircularTransition: NSObject {

    var circle = UIView()
    

    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    
    var circleColor = UIColor.white
    
    var duration = 0.7
    var viewDuration = 0.9
    enum CircularTransitionMode:Int {
        case present, dismiss, pop
    }
    
    var transitionMode:CircularTransitionMode = .present
    
}

extension CircularTransition:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.init(codeString: "#ffffff")
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
//                squar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.origin.y +  UIScreen.main.bounds.size.height / 2.0, width:  UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                
            
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = CGPoint(x:  UIScreen.main.bounds.size.width , y: UIScreen.main.bounds.size.height)
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                presentedView.frame = UIScreen.main.bounds
                presentedView.transform = CGAffineTransform(translationX: 0, y: 0 )
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
             
                UIView.animate(withDuration: viewDuration, animations: {
                      presentedView.alpha = 1
                }, completion: nil)
                
                
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    }, completion: { (success:Bool) in
                        transitionContext.completeTransition(success)
                })
            }
            
        }else{
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                //let viewCenter = returningView.center
              
                
                returningView.alpha = 0
            // circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                
//                squar.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.origin.y +  UIScreen.main.bounds.size.height / 2.0, width:  UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                
                
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = CGPoint(x:  UIScreen.main.bounds.size.width , y: UIScreen.main.bounds.size.height)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
//                    self.squar.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.origin.y +  UIScreen.main.bounds.size.height / 2.0 )
                  
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                    }
                    
                    
                    }, completion: { (success:Bool) in
                       // returningView.center = viewCenter
                        returningView.removeFromSuperview()
                        
                        self.circle.removeFromSuperview()
                        
                        transitionContext.completeTransition(success)
                        
                })
                
            }
            
            
        }
        
    }
    
    
    
    func frameForCircle (withViewCenter viewCenter:CGPoint, size viewSize:CGSize, startPoint:CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    
    }
    
    
    
    
    
    
    
    
    
    

}
