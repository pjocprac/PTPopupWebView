//
//  PopupWebViewController.swift
//  PTPopupWebView
//
//  Created by Takeshi Watanabe on 2016/03/19.
//  Copyright © 2016 Takeshi Watanabe. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class PTPopupWebViewController : UIViewController {
    public enum PTPopupWebViewControllerBackgroundStyle {
        // blur effect background
        case BlurEffect (UIBlurEffectStyle)
        // opacity background
        case Opacity (UIColor?)
        // transparent background
        case Transparent
    }
    
    public enum PTPopupWebViewControllerTransitionStyle {
        /// Transition without style.
        case None
        /// Transition with fade in/out effect.
        case Fade (NSTimeInterval)
        /// Transition with slide in/out effect.
        case Slide (PTPopupWebViewEffectDirection, NSTimeInterval, Bool)
        /// Transition with spread out/in style
        case Spread (NSTimeInterval)
        /// Transition with pop out/in style
        case Pop (NSTimeInterval, Bool)
    }
    
    public enum PTPopupWebViewEffectDirection {
        case Top, Bottom, Left, Right
    }
    
    @IBOutlet weak private var contentView : UIView!
    @IBOutlet weak private var blurView: UIVisualEffectView!

    /// PTPopupWebView
    public private(set) var popupView = PTPopupWebView().style(PTPopupWebViewControllerStyle())

    /// Background Style
    public private(set) var backgroundStyle : PTPopupWebViewControllerBackgroundStyle = .BlurEffect(.Dark)

    /// Transition Style
    public private(set) var transitionStyle : UIModalTransitionStyle = .CrossDissolve
    
    /// Popup Appear Style
    public private(set) var popupAppearStyle : PTPopupWebViewControllerTransitionStyle = .Pop(0.3, true)
    
    /// Popup Disappear Style
    public private(set) var popupDisappearStyle : PTPopupWebViewControllerTransitionStyle = .Pop(0.3, true)
    
    private let attributes = [
        NSLayoutAttribute.Top,
        NSLayoutAttribute.Left,
        NSLayoutAttribute.Bottom,
        NSLayoutAttribute.Right
    ]

    private var constraints : [NSLayoutAttribute : NSLayoutConstraint] = [:]
    
    override public func loadView() {
        let bundle = NSBundle(forClass: self.dynamicType)
        switch backgroundStyle {
        case .BlurEffect(let blurStyle):
            let nib = UINib(nibName: "PTPopupWebViewControllerBlur", bundle: bundle)
            view = nib.instantiateWithOwner(self, options: nil).first as! UIView
            blurView.effect = UIBlurEffect(style: blurStyle)
            
        case .Opacity(let color):
            let view = UIView(frame: UIScreen.mainScreen().bounds)
            
            self.view = view
            self.contentView = view
            self.contentView.backgroundColor = color
            
        case .Transparent:
            let view = UIView(frame: UIScreen.mainScreen().bounds)
            
            self.view = view
            self.contentView = view
            self.contentView.backgroundColor = .clearColor()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.delegate = self
        self.contentView.addSubview(popupView)
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        for attribute in attributes {
            let constraint = NSLayoutConstraint(
                item  : contentView, attribute: attribute, relatedBy: NSLayoutRelation.Equal,
                toItem: popupView,   attribute: attribute, multiplier: 1.0, constant: 0.0)
            contentView.addConstraint(constraint)
            constraints[attribute] = constraint
        }
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        switch popupAppearStyle {
        case .None: popupView.alpha = 1
        default   : popupView.alpha = 0
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        switch popupAppearStyle {
        case .None:
            break

        case .Fade (let duration):
            UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut], animations: {self.popupView.alpha = 1}, completion: nil)
            
        case .Slide(let direction, let duration, let damping):
            self.popupView.alpha = 1
            switch direction {
            case .Top   : self.popupView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.height)
            case .Bottom: self.popupView.transform = CGAffineTransformMakeTranslation(0,  self.view.bounds.height)
            case .Left  : self.popupView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
            case .Right : self.popupView.transform = CGAffineTransformMakeTranslation( self.view.bounds.width, 0)
            }
            let animations = {
                self.popupView.transform = CGAffineTransformMakeTranslation(0, 0)
            }
            if damping {
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: animations, completion: nil)
            }
            else {
                UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut], animations: animations, completion: nil)
            }
            
        case .Spread (let duration):
            popupView.alpha = 1

            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.popupView.layer.mask = nil
            })
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))

            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.whiteColor().CGColor
            maskLayer.cornerRadius = popupView.style?.cornerRadius ?? 0
            
            let oldBounds = CGRectZero
            let newBounds = popupView.contentView.bounds
            let revealAnimation = CABasicAnimation(keyPath: "bounds")
            revealAnimation.fromValue = NSValue(CGRect: oldBounds)
            revealAnimation.toValue = NSValue(CGRect: newBounds)
            revealAnimation.duration = duration
            maskLayer.frame = popupView.contentView.frame
            
            popupView.layer.mask = maskLayer
            maskLayer.addAnimation(revealAnimation, forKey: "revealAnimation")
            
            CATransaction.commit()
            
        case .Pop (let duration, let damping):
            popupView.alpha = 1
            popupView.transform = CGAffineTransformMakeScale(0, 0)

            let animations = {
                self.popupView.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            if damping {
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [.CurveEaseInOut], animations: animations, completion: nil)
            }
            else {
                UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut], animations: animations, completion: nil)
            }
        }
    }
    
    /**
     Set the background style (Default: .BlurEffect(.Dark))
     
     - parameters:
        - style: PTPopupWebViewControllerBackgroundStyle
     */
    public func backgroundStyle(style: PTPopupWebViewControllerBackgroundStyle) -> Self {
        self.backgroundStyle = style
        return self
    }

    /**
     Set the tansition style (Default: .CrossDissolve)

     - parameters:
        - style: UIModalTransitionStyle
     */
    public func transitionStyle(style: UIModalTransitionStyle) -> Self {
        self.transitionStyle = style
        return self
    }
    
    /**
     Set the popup appear style (Default: .None)

     - parameters:
        - style: PTPopupWebViewControllerTransitionStyle
     */
    public func popupAppearStyle(style: PTPopupWebViewControllerTransitionStyle) -> Self {
        self.popupAppearStyle = style
        return self
    }

    /**
     Set the popup disappear style (Default: .None)
     
     - parameters:
        - style: PTPopupWebViewControllerTransitionStyle
     */
    public func popupDisappearStyle(style: PTPopupWebViewControllerTransitionStyle) -> Self {
        self.popupDisappearStyle = style
        return self
    }

    /**
     Show the popup view.
     
     Transition from the ViewController, which is
     - foreground view controller (without argument)
     - specified view controller (with argument)

     - parameters:
        - presentViewController: transition source ViewController
     */
    public func show(presentViewController: UIViewController? = nil) {
        modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        modalTransitionStyle = self.transitionStyle
        
        if let presentViewController = presentViewController {
            presentViewController.presentViewController(self, animated: true, completion: nil)
        }
        else {
            var rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController;
            if rootViewController != nil {
                while ((rootViewController!.presentedViewController) != nil) {
                    rootViewController = rootViewController!.presentedViewController;
                }
                
                rootViewController!.presentViewController(self, animated: true, completion: nil)
            }
        }
    }
    
    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension PTPopupWebViewController : PTPopupWebViewDelegate {
    public func close() {
        let completion:(Bool) -> Void = { completed in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        switch popupDisappearStyle {
        case .None:
            completion(true)
            
        case .Fade (let duration):
            UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut], animations: {self.popupView.alpha = 0}, completion: completion)
            
        case .Slide(let direction, let duration, let damping):
            let animations = {
                switch direction {
                case .Top   : self.popupView.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.height)
                case .Bottom: self.popupView.transform = CGAffineTransformMakeTranslation(0,  self.view.bounds.height)
                case .Left  : self.popupView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
                case .Right : self.popupView.transform = CGAffineTransformMakeTranslation( self.view.bounds.width, 0)
                }
            }
            if damping {
                let springAnimations = {
                    switch direction {
                    case .Top   : self.popupView.transform = CGAffineTransformMakeTranslation(0,  self.popupView.bounds.height * 0.05)
                    case .Bottom: self.popupView.transform = CGAffineTransformMakeTranslation(0, -self.popupView.bounds.height * 0.05)
                    case .Left  : self.popupView.transform = CGAffineTransformMakeTranslation( self.popupView.bounds.width * 0.05, 0)
                    case .Right : self.popupView.transform = CGAffineTransformMakeTranslation(-self.popupView.bounds.width * 0.05, 0)
                    }
                }
                UIView.animateWithDuration(
                    duration/3, delay: 0, options: [.CurveEaseInOut],
                    animations: springAnimations,
                    completion: { completed in
                        UIView.animateWithDuration(
                            duration * 2/3, delay: 0, options: [.CurveEaseInOut],
                            animations: animations,
                            completion: completion)
                    })
            }
            else {
                UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseInOut], animations: animations, completion: nil)
            }
            
        case .Spread (let duration):
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                completion(true)
            })
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))

            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.whiteColor().CGColor
            maskLayer.cornerRadius = popupView.style?.cornerRadius ?? 0
            
            let oldBounds = popupView.contentView.bounds
            let newBounds = CGRectZero
            let revealAnimation = CABasicAnimation(keyPath: "bounds")
            revealAnimation.fromValue = NSValue(CGRect: oldBounds)
            revealAnimation.toValue = NSValue(CGRect: newBounds)
            revealAnimation.duration = duration
            revealAnimation.repeatCount = 0
            maskLayer.frame = popupView.contentView.frame
            maskLayer.bounds = CGRectZero
            
            popupView.layer.mask = maskLayer
            maskLayer.addAnimation(revealAnimation, forKey: "revealAnimation")
            
            CATransaction.commit()

        case .Pop (let duration, let damping):
            if damping {
                UIView.animateWithDuration(
                    duration/3, delay: 0, options: [.CurveEaseInOut],
                    animations: {
                        self.popupView.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    },
                    completion: { completed in
                        UIView.animateWithDuration(
                            duration * 2/3, delay: 0, options: [.CurveEaseInOut],
                            animations: {
                                self.popupView.transform = CGAffineTransformMakeScale(0.0000001, 0.0000001) // if 0, no animation
                            }, completion: completion)
                })
            }
            else {
                UIView.animateWithDuration(
                    duration, delay: 0, options: [.CurveEaseInOut],
                    animations: {
                        self.popupView.transform = CGAffineTransformMakeScale(0.0000001, 0.0000001)
                }, completion: completion)
            }
        }
    }
}