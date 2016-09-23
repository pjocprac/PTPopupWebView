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

open class PTPopupWebViewController : UIViewController {
    public enum PTPopupWebViewControllerBackgroundStyle {
        // blur effect background
        case blurEffect (UIBlurEffectStyle)
        // opacity background
        case opacity (UIColor?)
        // transparent background
        case transparent
    }
    
    public enum PTPopupWebViewControllerTransitionStyle {
        /// Transition without style.
        case none
        /// Transition with fade in/out effect.
        case fade (TimeInterval)
        /// Transition with slide in/out effect.
        case slide (PTPopupWebViewEffectDirection, TimeInterval, Bool)
        /// Transition with spread out/in style
        case spread (TimeInterval)
        /// Transition with pop out/in style
        case pop (TimeInterval, Bool)
    }
    
    public enum PTPopupWebViewEffectDirection {
        case top, bottom, left, right
    }
    
    @IBOutlet weak fileprivate var contentView : UIView!
    @IBOutlet weak fileprivate var blurView: UIVisualEffectView!

    /// PTPopupWebView
    open fileprivate(set) var popupView = PTPopupWebView().style(PTPopupWebViewControllerStyle())

    /// Background Style
    open fileprivate(set) var backgroundStyle : PTPopupWebViewControllerBackgroundStyle = .blurEffect(.dark)

    /// Transition Style
    open fileprivate(set) var transitionStyle : UIModalTransitionStyle = .crossDissolve
    
    /// Popup Appear Style
    open fileprivate(set) var popupAppearStyle : PTPopupWebViewControllerTransitionStyle = .pop(0.3, true)
    
    /// Popup Disappear Style
    open fileprivate(set) var popupDisappearStyle : PTPopupWebViewControllerTransitionStyle = .pop(0.3, true)
    
    fileprivate let attributes = [
        NSLayoutAttribute.top,
        NSLayoutAttribute.left,
        NSLayoutAttribute.bottom,
        NSLayoutAttribute.right
    ]

    fileprivate var constraints : [NSLayoutAttribute : NSLayoutConstraint] = [:]
    
    override open func loadView() {
        let bundle = Bundle(for: type(of: self))
        switch backgroundStyle {
        case .blurEffect(let blurStyle):
            let nib = UINib(nibName: "PTPopupWebViewControllerBlur", bundle: bundle)
            view = nib.instantiate(withOwner: self, options: nil).first as! UIView
            blurView.effect = UIBlurEffect(style: blurStyle)
            
        case .opacity(let color):
            let view = UIView(frame: UIScreen.main.bounds)
            
            self.view = view
            self.contentView = view
            self.contentView.backgroundColor = color
            
        case .transparent:
            let view = UIView(frame: UIScreen.main.bounds)
            
            self.view = view
            self.contentView = view
            self.contentView.backgroundColor = .clear
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.delegate = self
        self.contentView.addSubview(popupView)
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        for attribute in attributes {
            let constraint = NSLayoutConstraint(
                item  : contentView, attribute: attribute, relatedBy: NSLayoutRelation.equal,
                toItem: popupView,   attribute: attribute, multiplier: 1.0, constant: 0.0)
            contentView.addConstraint(constraint)
            constraints[attribute] = constraint
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch popupAppearStyle {
        case .none: popupView.alpha = 1
        default   : popupView.alpha = 0
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch popupAppearStyle {
        case .none:
            break

        case .fade (let duration):
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {self.popupView.alpha = 1}, completion: nil)
            
        case .slide(let direction, let duration, let damping):
            self.popupView.alpha = 1
            switch direction {
            case .top   : self.popupView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
            case .bottom: self.popupView.transform = CGAffineTransform(translationX: 0,  y: self.view.bounds.height)
            case .left  : self.popupView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
            case .right : self.popupView.transform = CGAffineTransform( translationX: self.view.bounds.width, y: 0)
            }
            let animations = {
                self.popupView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            if damping {
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: animations, completion: nil)
            }
            else {
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: animations, completion: nil)
            }
            
        case .spread (let duration):
            popupView.alpha = 1

            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.popupView.layer.mask = nil
            })
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))

            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.white.cgColor
            maskLayer.cornerRadius = popupView.style?.cornerRadius ?? 0
            
            let oldBounds = CGRect.zero
            let newBounds = popupView.contentView.bounds
            let revealAnimation = CABasicAnimation(keyPath: "bounds")
            revealAnimation.fromValue = NSValue(cgRect: oldBounds)
            revealAnimation.toValue = NSValue(cgRect: newBounds)
            revealAnimation.duration = duration
            maskLayer.frame = popupView.contentView.frame
            
            popupView.layer.mask = maskLayer
            maskLayer.add(revealAnimation, forKey: "revealAnimation")
            
            CATransaction.commit()
            
        case .pop (let duration, let damping):
            popupView.alpha = 1
            popupView.transform = CGAffineTransform(scaleX: 0, y: 0)

            let animations = {
                self.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
            if damping {
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: animations, completion: nil)
            }
            else {
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: animations, completion: nil)
            }
        }
    }
    
    /**
     Set the background style (Default: .BlurEffect(.Dark))
     
     - parameters:
        - style: PTPopupWebViewControllerBackgroundStyle
     */
    open func backgroundStyle(_ style: PTPopupWebViewControllerBackgroundStyle) -> Self {
        self.backgroundStyle = style
        return self
    }

    /**
     Set the tansition style (Default: .CrossDissolve)

     - parameters:
        - style: UIModalTransitionStyle
     */
    open func transitionStyle(_ style: UIModalTransitionStyle) -> Self {
        self.transitionStyle = style
        return self
    }
    
    /**
     Set the popup appear style (Default: .None)

     - parameters:
        - style: PTPopupWebViewControllerTransitionStyle
     */
    open func popupAppearStyle(_ style: PTPopupWebViewControllerTransitionStyle) -> Self {
        self.popupAppearStyle = style
        return self
    }

    /**
     Set the popup disappear style (Default: .None)
     
     - parameters:
        - style: PTPopupWebViewControllerTransitionStyle
     */
    open func popupDisappearStyle(_ style: PTPopupWebViewControllerTransitionStyle) -> Self {
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
    open func show(_ presentViewController: UIViewController? = nil) {
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = self.transitionStyle
        
        if let presentViewController = presentViewController {
            presentViewController.present(self, animated: true, completion: nil)
        }
        else {
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController;
            if rootViewController != nil {
                while ((rootViewController!.presentedViewController) != nil) {
                    rootViewController = rootViewController!.presentedViewController;
                }
                
                rootViewController!.present(self, animated: true, completion: nil)
            }
        }
    }
    
    override open var prefersStatusBarHidden : Bool {
        return true
    }
}

extension PTPopupWebViewController : PTPopupWebViewDelegate {
    public func close() {
        let completion:(Bool) -> Void = { completed in
            self.dismiss(animated: true, completion: nil)
        }
        
        switch popupDisappearStyle {
        case .none:
            completion(true)
            
        case .fade (let duration):
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: {self.popupView.alpha = 0}, completion: completion)
            
        case .slide(let direction, let duration, let damping):
            let animations = {
                switch direction {
                case .top   : self.popupView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
                case .bottom: self.popupView.transform = CGAffineTransform(translationX: 0,  y: self.view.bounds.height)
                case .left  : self.popupView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
                case .right : self.popupView.transform = CGAffineTransform( translationX: self.view.bounds.width, y: 0)
                }
            }
            if damping {
                let springAnimations = {
                    switch direction {
                    case .top   : self.popupView.transform = CGAffineTransform(translationX: 0,  y: self.popupView.bounds.height * 0.05)
                    case .bottom: self.popupView.transform = CGAffineTransform(translationX: 0, y: -self.popupView.bounds.height * 0.05)
                    case .left  : self.popupView.transform = CGAffineTransform( translationX: self.popupView.bounds.width * 0.05, y: 0)
                    case .right : self.popupView.transform = CGAffineTransform(translationX: -self.popupView.bounds.width * 0.05, y: 0)
                    }
                }
                UIView.animate(
                    withDuration: duration/3, delay: 0, options: UIViewAnimationOptions(),
                    animations: springAnimations,
                    completion: { completed in
                        UIView.animate(
                            withDuration: duration * 2/3, delay: 0, options: UIViewAnimationOptions(),
                            animations: animations,
                            completion: completion)
                    })
            }
            else {
                UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: animations, completion: nil)
            }
            
        case .spread (let duration):
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                completion(true)
            })
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))

            let maskLayer = CALayer()
            maskLayer.backgroundColor = UIColor.white.cgColor
            maskLayer.cornerRadius = popupView.style?.cornerRadius ?? 0
            
            let oldBounds = popupView.contentView.bounds
            let newBounds = CGRect.zero
            let revealAnimation = CABasicAnimation(keyPath: "bounds")
            revealAnimation.fromValue = NSValue(cgRect: oldBounds)
            revealAnimation.toValue = NSValue(cgRect: newBounds)
            revealAnimation.duration = duration
            revealAnimation.repeatCount = 0
            maskLayer.frame = popupView.contentView.frame
            maskLayer.bounds = CGRect.zero
            
            popupView.layer.mask = maskLayer
            maskLayer.add(revealAnimation, forKey: "revealAnimation")
            
            CATransaction.commit()

        case .pop (let duration, let damping):
            if damping {
                UIView.animate(
                    withDuration: duration/3, delay: 0, options: UIViewAnimationOptions(),
                    animations: {
                        self.popupView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    },
                    completion: { completed in
                        UIView.animate(
                            withDuration: duration * 2/3, delay: 0, options: UIViewAnimationOptions(),
                            animations: {
                                self.popupView.transform = CGAffineTransform(scaleX: 0.0000001, y: 0.0000001) // if 0, no animation
                            }, completion: completion)
                })
            }
            else {
                UIView.animate(
                    withDuration: duration, delay: 0, options: UIViewAnimationOptions(),
                    animations: {
                        self.popupView.transform = CGAffineTransform(scaleX: 0.0000001, y: 0.0000001)
                }, completion: completion)
            }
        }
    }
}
