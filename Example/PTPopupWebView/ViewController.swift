//
//  ViewController.swift
//  PTPopupWebView
//
//  Created by Takeshi Watanabe on 03/23/2016.
//  Copyright (c) 2016 Takeshi Watanabe. All rights reserved.
//

import UIKit
import PTPopupWebView

class ViewController: UIViewController {
    
    // Demo URL
    let url = NSURL(string: "https://github.com/pjocprac/PTPopupWebView/blob/master/README.md")
    
    // Scroll View
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        scrollView.addConstraint(NSLayoutConstraint(
            item  : contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: scrollView , attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|", options: [], metrics: nil, views: ["contentView":contentView]))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: [], metrics: nil, views: ["contentView":contentView]))
        
        
        let color = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
        
        let label = UILabel()
        label.text = "PTPopupWebView Demo"
        label.textColor = color
        label.font = UIFont.boldSystemFontOfSize(24)
        label.frame = CGRectMake(0, 60, self.view.bounds.width, 60)
        label.textAlignment = .Center
        
        contentView.addSubview(label)
        
        var containerViews : [UIView] = []
        var lastView : UIView = label
        
        let margin : CGFloat = 8.0
        for (title, description) in demolist {
            let containerView = UIView()
            containerViews.append(containerView)
            
            containerView.translatesAutoresizingMaskIntoConstraints = false
            if title[title.startIndex] != "*" {
                containerView.tag = title.hash
                containerView.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: "tapped:")
                containerView.addGestureRecognizer(tap)
            }
            containerView.layer.cornerRadius = 8
            
            // Button
            let titleView : UIView
            if title[title.startIndex] == "*" {
                let sectionLabel = UILabel()
                sectionLabel.text = title.substringFromIndex(title.startIndex.advancedBy(1))
                sectionLabel.font = UIFont.boldSystemFontOfSize(24)
                sectionLabel.textAlignment = .Left
                sectionLabel.textColor = .darkGrayColor()
                
                titleView = sectionLabel
            }
            else {
                let titleLabel = UILabel()
                titleLabel.text = title
                titleLabel.font = UIFont.boldSystemFontOfSize(22)
                titleLabel.textAlignment = .Left
                titleLabel.textColor = color
                
                titleView = titleLabel
            }
            containerView.addSubview(titleView)
            titleView.frame = CGRectMake(0, 0, 0, 30)
            let labelsize = label.sizeThatFits(CGSizeMake(self.view.bounds.width - margin * 2, CGFloat.max))
            titleView.frame = CGRectMake(margin, 0, labelsize.width, labelsize.height)
            titleView.sizeToFit()
            
            
            // Description
            let descriptionLabel = UILabel()
            descriptionLabel.text = description
            descriptionLabel.textColor = .darkGrayColor()
            descriptionLabel.font = UIFont.systemFontOfSize(14)
            
            containerView.addSubview(descriptionLabel)
            descriptionLabel.numberOfLines = 0
            let size = descriptionLabel.sizeThatFits(CGSizeMake(self.view.bounds.width - margin * 2, CGFloat.max))
            descriptionLabel.frame = CGRectMake(margin, 0, size.width, size.height)
            descriptionLabel.sizeToFit()
            
            contentView.addSubview(containerView)
            
            let views = ["containerView":containerView, "lastView": lastView, "titleView" : titleView, "descriptionLabel" : descriptionLabel]
            titleView.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            let margin = description == "" ? 0 : 8
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[titleView]-0-[descriptionLabel]-\(margin)-|", options: [], metrics: nil, views: views))
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[titleView]-8-|", options: [], metrics: nil, views: views))
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[descriptionLabel]-8-|", options: [], metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[lastView][containerView]", options: [], metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[containerView]-8-|", options: [], metrics: nil, views: views))
            lastView = containerView
        }
        contentView.layoutSubviews()
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[lastView]-32-|", options: [], metrics: nil, views: ["lastView": lastView]))
        contentView.frame = CGRectMake(0, 0, scrollView.bounds.width, lastView.frame.origin.y + lastView.frame.height + 32)
        scrollView.contentSize = contentView.bounds.size
        
        lastView.userInteractionEnabled = true
        let tap = UILongPressGestureRecognizer(target: self, action: "pressed:")
        lastView.addGestureRecognizer(tap)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tapped (sender: UIGestureRecognizer) {
        let url = NSURL(string: "https://github.com/pjocprac/PTPopupWebView/blob/master/README.md")
        
        // Initialize and set URL
        let vc : PTPopupWebViewController = PTPopupWebViewController()
        vc.popupView.URL(url)
        
        if let view = sender.view {
            let popup = {
                switch view.tag {
                case "Default".hash:
                    break
                    
                case "Background Style".hash:
                    vc.backgroundStyle(.Opacity(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)))
                    break
                    
                case "Transition Style".hash:
                    vc.transitionStyle(.FlipHorizontal)
                    break
                    
                case "Fade".hash:
                    vc.popupAppearStyle(.Fade(0.25))
                    vc.popupDisappearStyle(.Fade(0.25))
                    break
                case "Slide".hash:
                    vc.popupAppearStyle(.Slide(.Bottom, 0.4, true))
                    vc.popupView
                        .addButton(PTPopupWebViewButton(type: .Custom)
                            .title("Top").handler() {
                                vc.popupDisappearStyle(.Slide(.Top, 0.4, true))
                                vc.close()
                            })
                        .addButton(PTPopupWebViewButton(type: .Custom)
                            .title("Bottom").handler() {
                                vc.popupDisappearStyle(.Slide(.Bottom, 0.4, true))
                                vc.close()
                            })
                        .addButton(PTPopupWebViewButton(type: .Custom)
                            .title("Left").handler() {
                                vc.popupDisappearStyle(.Slide(.Left, 0.4, true))
                                vc.close()
                            })
                        .addButton(PTPopupWebViewButton(type: .Custom)
                            .title("Right").handler() {
                                vc.popupDisappearStyle(.Slide(.Right, 0.4, true))
                                vc.close()
                            })
                    break
                case "Spread".hash:
                    vc.popupAppearStyle(.Spread(0.20))
                    vc.popupDisappearStyle(.Spread(0.20))
                    break

                case "Pop".hash:
                    vc.popupAppearStyle(.Pop(0.30, true))
                    vc.popupDisappearStyle(.Pop(0.30, true))
                    break

                    
                case "Close Action".hash:
                    vc.popupView
                        .addButton(PTPopupWebViewButton(type: .Close).useDefaultImage().title("close"))
                    break
                    
                case "Navigation Control Actions".hash:
                    let style = PTPopupWebViewControllerStyle()
                        .buttonDistribution(.Proportional)
                    
                    vc.popupView
                        .style(style)
                        .addButton(PTPopupWebViewButton(type: .Back).useDefaultImage())
                        .addButton(PTPopupWebViewButton(type: .Forward).useDefaultImage())
                        .addButton(PTPopupWebViewButton(type: .Reload).useDefaultImage())
                        .addButton(PTPopupWebViewButton(type: .Close).useDefaultImage().title("close"))
                    break
                    
                case "Open Link Action".hash:
                    vc.popupView
                        .addExternalLinkPattern(.URLScheme)
                        .addButton(PTPopupWebViewButton(type: .Link(NSURL(string: "https://github.com/")!)).title("github top"))
                        .addButton(PTPopupWebViewButton(type: .LinkClose(NSURL(string: "itms-apps://itunes.apple.com/")!)).title("itunes"))
                        .addButton(PTPopupWebViewButton(type: .Close).useDefaultImage().title("close"))
                    break
                    
                case "Custom Image Button".hash:
                    vc.popupView
                        .addButton(
                            PTPopupWebViewButton(type: .Reload)
                                .image(UIImage(named: "demo")?.imageWithRenderingMode(.AlwaysTemplate))
                                .title("custom"))
                        .addButton(
                            PTPopupWebViewButton(type: .Close)
                                .useDefaultImage()
                                .title("close"))
                    
                case "Custom Action".hash:
                    let handler = {
                        let alert:UIAlertController = UIAlertController(
                            title: "Custom Action",
                            message: "Web page title is \"\(vc.popupView.webView.title!)\"", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        vc.presentViewController(alert, animated: true, completion: {})
                    }
                    vc.popupView
                        .addButton(
                            PTPopupWebViewButton(type: .Custom)
                                .image(UIImage(named: "demo")?.imageWithRenderingMode(.AlwaysTemplate))
                                .handler(handler)
                                .title("custom"))
                        .addButton(PTPopupWebViewButton(type: .Close).useDefaultImage().title("close"))
                    
                    
                    
                case "Colored Title".hash:
                    let style = PTPopupWebViewControllerStyle()
                        .titleBackgroundColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1))
                        .titleForegroundColor(.whiteColor())
                    vc.popupView.style(style)
                    
                case "Hide Title".hash:
                    let style = PTPopupWebViewControllerStyle()
                        .titleHidden(true)
                    vc.popupView.style(style)
                    
                case "Colored Button".hash:
                    vc.popupView
                        .addButton(
                            PTPopupWebViewButton(type: .Back)
                                .backgroundColor(UIColor(red: 44/255, green: 183/255, blue: 107/255, alpha: 1))
                                .useDefaultImage())
                        .addButton(
                            PTPopupWebViewButton(type: .Forward)
                                .backgroundColor(UIColor(red: 243/255, green: 203/255, blue: 11/255, alpha: 1))
                                .useDefaultImage())
                        .addButton(
                            PTPopupWebViewButton(type: .Reload)
                                .backgroundColor(UIColor(red: 233/255, green: 138/255, blue: 37/255, alpha: 1))
                                .useDefaultImage())
                        .addButton(
                            PTPopupWebViewButton(type: .Close)
                                .backgroundColor(UIColor(red: 234/255, green: 87/255, blue: 68/255, alpha: 1))
                                .useDefaultImage())
                    
                    let style = PTPopupWebViewControllerStyle()
                        .titleBackgroundColor(UIColor(red: 59/255, green: 83/255, blue: 105/255, alpha: 1))
                        .titleForegroundColor(.whiteColor())
                        .buttonForegroundColor(.whiteColor())
                        .buttonDisabledColor(.whiteColor())
                    vc.popupView.style(style)
                    
                case "Hide Button".hash:
                    let style = PTPopupWebViewControllerStyle()
                        .titleBackgroundColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1))
                        .titleForegroundColor(.whiteColor())
                        .buttonHidden(true)
                        .closeButtonHidden(false)
                    vc.popupView.style(style)
                    
                case "Full Screen".hash:
                    let style = PTPopupWebViewStyle()
                        .titleHidden(true)
                        .cornerRadius(0)
                    vc.popupView.style(style)
                    
                case "With Frame".hash:
                    let style = PTPopupWebViewControllerStyle()
                        .innerMargin(UIEdgeInsetsMake(0, 8, 0, 8))
                        .backgroundColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1))
                        .titleForegroundColor(.whiteColor())
                        .buttonForegroundColor(.whiteColor())
                    vc.popupView.style(style)
                    
                case "Directly Use PTPopupWebView".hash:
                    return
                    
                default:
                    break
                }
                
                // show PTPopupWebViewController
                vc.show()
            }
            
            // touch animation
            UIView.animateWithDuration(
                0.25,
                animations: {
                    view.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0.2)
                },
                completion: { _ in
                    UIView.animateWithDuration(
                        0.4,
                        animations: {
                            view.backgroundColor = .clearColor()
                        },
                        completion: { _ in
                            popup()
                        }
                    )
                }
            )
            
        }
    }
    
    func pressed (sender: UIGestureRecognizer) {
        switch (sender.state) {
        case .Began:
            if let view = sender.view {
                let popup = PTPopupWebView(frame: CGRectMake(10, 40, UIScreen.mainScreen().bounds.width - 20, view.frame.origin.y - scrollView.contentOffset.y - 50))
                let style = PTPopupWebViewStyle()
                    .titleHidden(true)
                    .buttonHidden(true)
                popup
                    .URL(string: "https://github.com/")
                    .style(style)
                
                popup.layer.masksToBounds = false
                popup.layer.shadowOffset = CGSizeMake(2.0, 2.0)
                popup.layer.shadowOpacity = 0.3
                popup.layer.shadowColor = UIColor.lightGrayColor().CGColor
                popup.layer.shadowRadius = 2.0
                self.view.addSubview(popup)
            }
        case .Ended, .Cancelled:
            for view in self.view.subviews {
                if let popup = view as? PTPopupWebView {
                    popup.removeFromSuperview()
                }
            }
            break
        default:
            break
        }
    }
    
    // Demo List [Title:description]
    private var demolist : [(String,String)] = [
        ("*", "(Tap the items of green title, you can see the demo.)"),
        ("*", "PTPopupWebView is the simple and useful WebView, which can be popup, and has many of the customized item, you can use immediately in you want to use style. To use, there are two ways,\n1) use PTPopupWebViewController. (when use as modal popup, this is simple way),\n2) directly use PTPopupWebView."),
        
        ("*PTPopupWebViewController", "PTPopupWebViewController is UIViewController that wraps the PTPopupWebView. The methods, show() and close(), are used to control modal view. The properties, backgroundStyle, transitionStyle, popupAppearStyle, and popupDisappearStyle are the additional from PTPopupWebView. By accessing to \"popupView\" property, it can customize PTPopupWebView's style and buttons etc."),
        
        ("Default",
            "PTPopupWebViewController without style and configuration modification."),
        
        ("*Popup Transition Style", "When using PTPopupWebViewController, Popup Appear/Disappear Style (below) can be used. (default None)"),
        ("Slide",
            "SlideIn/Out transition. The animation direction and duration, whether to do spring effect must be set. e.g. .Slide(.Bottom, 0.40, true)"),
        ("Pop",
            "PopOut/In transition with content scalling. The animation duration, whether to do spring effect must be set. e.g. .Pop(0.30, true)"),
        ("Spread",
            "SpreadOut/In transition without content scalling. The animation duration must be set. e.g. .Spread(0.20)"),
        ("Fade",
            "FadeIn/Out transition. The animation duration must be set. e.g. .Fade(0.25)"),

        ("*Other Properties", ""),
        ("Background Style",
            "Background Style can be selected from BlurEffect (with UIBlurEffectStyle), Opacity (with UIColor), and Transparent. This demo is set the background style to opacity(green color). Default background style is BlurEffect(Dark)."),
        ("Transition Style",
            "Transition Style can be selected from UIModalTransitionStyle. This demo is set the transition style to FlipHorizontal. Default transition style is CrossDisolve."),
        
        ("*PTPopupWebView Customize", ""),

        ("*Style", "PTPopupWebView can modify detail of the view appearance of the content view, title bar, button area, etc. The style can modify by two ways.\n1) create instance of PTPopupWebViewStyle class and modify style parameters.\n2) define the class extends PTPopupWebViewStyle and modify style parameter at initilizer."),
        ("Colored Title",
            "The title bar have modifiable two colors, foreground color (e,g, text color), and background color."),
        ("Hide Title",
            "The title bar can be hidden, and the height of title bar is also modifiable."),
        ("Colored Button",
            "The buttons have modifiable three colors, foreground color (e,g, text color), disabled-foreground color, and background color."),
        ("Custom Image Button",
            "The buttons can be used custom image. The custom image is set by PTPopupWebView Button's function image()."),
        ("Hide Button",
            "The buttons can be hidden. And you can use close button which arranged at right-top with image 'x', instead of close button in button area. And the height of button is also modifiable."),

        ("Full Screen",
            "It is possible used as fullscreen view by set parameters outerMargin = UIEdgeInsetsZero, and cornerRadius = 0.0."),
        ("With Frame",
            "The inner margin is the spacing around webview, with UIEdgeInsets."),

        ("*Button Actions", "The buttons of PTPopupWebView have multiple functions, closing popup (Close), web navigation (Back, Forward, Reload), open link (Link, LinkClose), and custom action (Custom). The actions can use by initialize PTPopupWebViewButton with type e.g. init(type: .Close)"),
        
        ("Close Action",
            "Close Action provide the simplest function, 'only close popup'. If the button has not set, close button is automatically adds."),
        ("Navigation Control Actions",
            "Navigation Control Actions are available. 'Back', 'Forward', and 'Reload' button are builtin and these type have default image and can use by PTPopupWebView Button's function useDefaultImage()."),
        ("Open Link Action",
            "Open Link Action provide open link function. The link url is opened in web view by default. Or is opened by iOS default action, when the url matches the external link patterns. The external link patterns can be added by PTPopupWebView's function addExternalLinkPattern()."),
        ("Custom Action",
            "Custom Action provide the user defined action. The user defined function is set by PTPopupWebViewButton's handle() function."),
        
        
        ("*Others...", ""),
        ("Directly Use", "(Long Press Here!) above examples are using PTPopupWebViewController and modal view. Here it is direct use example of PTPopupWebView, like the 3D touch popup in iPhone 6s."),
        
    ]
}

