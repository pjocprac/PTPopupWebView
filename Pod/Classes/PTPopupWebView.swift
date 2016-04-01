//
//  PTPopupWebView.swift
//  PTPopupWebView
//
//  Created by Takeshi Watanabe on 2016/03/19.
//  Copyright © 2016 Takeshi Watanabe. All rights reserved.
//

import WebKit

protocol PTPopupWebViewDelegate {
    func close()
}

public class PTPopupWebView : UIView {
    internal var delegate : PTPopupWebViewDelegate?
    
    /* IBOutlet */
    // Outer Margin (The spacing between frame and contetnt view)
    @IBOutlet weak internal var outerMarginTop    : NSLayoutConstraint!
    @IBOutlet weak internal var outerMarginBottom : NSLayoutConstraint!
    @IBOutlet weak internal var outerMarginLeft   : NSLayoutConstraint!
    @IBOutlet weak internal var outerMarginRight  : NSLayoutConstraint!
    
    // Inner Margin (The spacing between contetnt view and webview)
    @IBOutlet weak internal var innerMarginTop    : NSLayoutConstraint!
    @IBOutlet weak internal var innerMarginBottom : NSLayoutConstraint!
    @IBOutlet weak internal var innerMarginLeft   : NSLayoutConstraint!
    @IBOutlet weak internal var innerMarginRight  : NSLayoutConstraint!
    
    // Contents view
    @IBOutlet weak internal var contentView: UIView!

    // Title
    @IBOutlet weak internal var titleViewHeight : NSLayoutConstraint!
    @IBOutlet weak internal var titleView       : UIView!
    @IBOutlet weak internal var titleLabel      : UILabel!

    // Buttons
    @IBOutlet weak internal var buttonContainerHeight : NSLayoutConstraint!
    @IBOutlet weak internal var buttonContainer       : UIView!

    // Close button
    @IBOutlet weak internal var closeButton : UIButton!

    // Web view container (WKWebView can not be allocated on the StoryBoard)
    @IBOutlet weak internal var webViewContainer : UIView!
    public private(set) var webView = WKWebView()


    /* Property */
    
    /// Title text
    public private(set) var title : String? {
        didSet {
            self.titleLabel?.text = title
        }
    }
    /// URL
    public private(set) var URL : NSURL? {
        didSet {
            if let URL = URL {
                let request = NSURLRequest(URL: URL)
                webView.loadRequest(request)
            }
        }
    }
    /// Content
    public private(set) var content : String? {
        didSet {
            if let content = content {
                webView.loadHTMLString(content, baseURL: nil)
            }
            else {
                webView.loadHTMLString("", baseURL: nil)
            }
        }
    }
    /// View Style
    public private(set) var style : PTPopupWebViewStyle?

    /**
     Title text.
     If valuse is nil, displays web page's title.
     If you want to specify the title text instead of web page's title, set this paramaeter.

     -parameters:
        - title: title text
     */
    public func title(title: String?) -> Self {
        self.title = title
        return self
    }

    
    /**
     URL

     - parameters:
        - URL: URL
     */
    public func URL(URL: NSURL?) -> Self {
        self.URL = URL
        return self
    }
    /**
     URL

     - parameters:
        - string: URL string
     */
    public func URL(string urlString: String) -> Self {
        URL(NSURL(string: urlString))
        return self
    }

    

    /**
     Webview's contents text.
     If you want to specify the display contents in the text instead of Web resources, set this parameter.
     
     - parameters:
        - content: contents text
     */
    public func content(content: String?) -> Self {
        self.content = content
        return self
    }


    
    /**
     View Style.
     To customize the style, you choose one of below way.
     1) generate a PTPopupWebViewStyle instance and change the parameters.
     2) define the Style class extends PTPopupWebViewStyle, and change the parameters in initializer

     - parameters:
        - style: style instance
     */
    public func style(style: PTPopupWebViewStyle) -> Self {
        self.style = style
        return self
    }




    /// External link patterns (open with iOS system)
    public private(set) var externalLinkPattern : [String] = []
    
    /// button settings
    private var buttonSettings : [PTPopupWebViewButton] = []
    
    /// UIButtons
    private var buttons : [UIButton] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    private func loadView() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "PTPopupWebView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)

        // Add KeyValue observer for webview
        webView.addObserver(self, forKeyPath:"title", options:.New, context:nil)
        webView.addObserver(self, forKeyPath:"URL", options:.New, context:nil)
        webView.addObserver(self, forKeyPath:"load" , options:.New, context:nil)
        webView.addObserver(self, forKeyPath:"estimatedProgress" , options:.New, context:nil)
    }

    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        // when remove from super view
        if newSuperview == nil {
            return
        }

        let style : PTPopupWebViewStyle
        if self.style == nil {
            self.style = PTPopupWebViewStyle()
        }
        style = self.style!
        
        // Outer margin initialize
        outerMarginTop.constant     = style.outerMargin.top
        outerMarginBottom.constant  = style.outerMargin.bottom
        outerMarginLeft.constant    = style.outerMargin.left
        outerMarginRight.constant   = style.outerMargin.right
        
        // Inner margin initialize
        innerMarginTop.constant     = style.innerMargin.top
        innerMarginBottom.constant  = style.innerMargin.bottom
        innerMarginLeft.constant    = style.innerMargin.left
        innerMarginRight.constant   = style.innerMargin.right
        
        // Content view initialize
        contentView.backgroundColor = style.backgroundColor
        if style.cornerRadius > 0 {
            contentView.layer.cornerRadius = style.cornerRadius
            contentView.layer.masksToBounds = true
        }

        // Title initialize
        titleLabel.text = title
        titleLabel.textColor = style.titleForegroundColor
        titleLabel.font = style.titleFont
        titleView.backgroundColor = style.titleBackgroundColor
        titleView.hidden = style.titleHidden
        titleViewHeight.constant = style.titleHeight

        if style.titleHidden {
            innerMarginTop.constant -= titleView.bounds.height
        }
        
        buttonContainer.hidden = style.buttonHidden
        if style.buttonHidden {
            innerMarginBottom.constant -= buttonContainer.bounds.height
        }
        else {
            buttonContainerHeight.constant = style.buttonHeight
        }
        
        // Button initialize
        // if not exists button settings, add default button ('close' button)
        if buttonSettings.count == 0 {
            buttonSettings.append(PTPopupWebViewButton(type: .Close).title("close"))
        }
        for buttonSetting in buttonSettings {
            let button = UIButton()
            button.titleLabel?.font = buttonSetting.font ?? style.buttonFont
            button.setTitle(buttonSetting.title, forState: .Normal)
            button.setTitleColor(buttonSetting.foregroundColor ?? style.buttonForegroundColor, forState: .Normal)
            button.setTitleColor(buttonSetting.disabledColor ?? style.buttonDisabledColor, forState: .Disabled)
            button.backgroundColor = buttonSetting.backgroundColor ?? style.buttonBackgroundColor
            button.setImage(buttonSetting.image, forState: .Normal)
            
            // Forward/Back/Reload's initial state is disabled
            switch buttonSetting.type {
            case .Forward, .Back, .Reload:
                button.enabled = false
                button.tintColor = buttonSetting.disabledColor ?? style.buttonDisabledColor
            default:
                button.tintColor = buttonSetting.foregroundColor ?? style.buttonForegroundColor
            }
            
            // observe enabled property for coloring
            button.addObserver(self, forKeyPath:"enabled", options:.New, context:nil)
            
            
            button.adjustsImageWhenHighlighted = false
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            buttonContainer.addSubview(button)
            buttons.append(button)
        }

        // add constraints for buttons
        for i in 0 ..< buttons.count {
            let button = buttons[i]
            // Top/Bottom to container is 0
            for attribute in [NSLayoutAttribute.Top, NSLayoutAttribute.Bottom] {
                buttonContainer.addConstraint(
                    NSLayoutConstraint(
                        item  : button,          attribute: attribute, relatedBy: NSLayoutRelation.Equal,
                        toItem: buttonContainer, attribute: attribute, multiplier: 1.0, constant: 0.0)
                )
            }
            
            // Leading constraint
            let leftItem      = i == 0 ? buttonContainer : buttons[i - 1]
            let leftAttribute = i == 0 ? NSLayoutAttribute.Leading : NSLayoutAttribute.Trailing
            buttonContainer.addConstraint(
                NSLayoutConstraint(
                    item  : button,   attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
                    toItem: leftItem, attribute: leftAttribute, multiplier: 1.0, constant: 0.0)
            )
            
            // Trailing constraint
            let rightItem      = i == buttons.count - 1 ? buttonContainer : buttons[i + 1]
            let rightAttribute = i == buttons.count - 1 ? NSLayoutAttribute.Trailing : NSLayoutAttribute.Leading
            buttonContainer.addConstraint(
                NSLayoutConstraint(
                    item  : button,    attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal,
                    toItem: rightItem, attribute: rightAttribute, multiplier: 1.0, constant: 0.0)
            )
        }

        switch style.buttonDistribution {
        case .Equal:
            // Equal width constraints
            for i in 1 ..< buttons.count {
                buttonContainer.addConstraint(
                    NSLayoutConstraint(
                        item  : buttons[0], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
                        toItem: buttons[i], attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0.0)
                )
            }
            
        case .Proportional:
            // Equal width constraints with constant, is difference of buttons content's width
            let baseWidth = calcContentWidth(buttons[0])
            for i in 1 ..< buttons.count {
                let diffWidth = baseWidth - calcContentWidth(buttons[i])
                buttonContainer.addConstraint(
                    NSLayoutConstraint(
                        item  : buttons[0], attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
                        toItem: buttons[i], attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: diffWidth)
                )
            }
        }
        
        // Close button
        closeButton.hidden = style.closeButtonHidden
        if !style.closeButtonHidden {
            let bundle = NSBundle(forClass: PTPopupWebViewButton.self)
            let image = UIImage(named: "close", inBundle: bundle, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(.AlwaysTemplate)
            
            closeButton.setImage(image, forState: .Normal)
            closeButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
            closeButton.addTarget(self, action: "close", forControlEvents: .TouchUpInside)
        }

        // Web view
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        for attribute in [NSLayoutAttribute.Top, NSLayoutAttribute.Leading, NSLayoutAttribute.Bottom, NSLayoutAttribute.Trailing] {
            webViewContainer.addConstraint(
                NSLayoutConstraint(
                    item  : webViewContainer, attribute: attribute, relatedBy: NSLayoutRelation.Equal,
                    toItem: webView,          attribute: attribute, multiplier: 1.0, constant: 0.0)
            )
        }
        
        // WKNavigationDelegate
        webView.navigationDelegate = self
    }
    
    deinit {
        // Remove KeyValue observer for webview
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "URL")
        webView.removeObserver(self, forKeyPath: "load")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
        for button in buttons {
            button.removeObserver(self, forKeyPath: "enabled")
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === webView {
            if let keyPath = keyPath {
                switch keyPath {
                case "title":
                    if title == nil {
                        if let change = change {
                            titleLabel.text = change[NSKeyValueChangeNewKey] as? String
                        } else {
                            titleLabel.text = nil
                        }
                    }
                    break;
                case "URL":
                    break;
                case "load":
                    break;
                case "estimatedProgress":
                    for i in 0 ..< buttonSettings.count {
                        let buttonSetting = buttonSettings[i]
                        switch buttonSetting.type {
                        case .Back    :
                            // To enable the Back button, when there is history.
                            buttons[i].enabled = webView.canGoBack
                        case .Forward :
                            // To enable the Forward button, when there is advance history.
                            buttons[i].enabled = webView.canGoForward
                        case .Reload  :
                            // To enable the update button, after completion of reading.
                            if let change = change, let progress = change[NSKeyValueChangeNewKey] as? Double {
                                buttons[i].enabled = progress == 1.0
                            }
                        default       : break
                        }
                    }
                    break;
                default:
                    break
                }
            }
        }
        else if let button = object as? UIButton {
            if let keyPath = keyPath {
                switch keyPath {
                case "enabled":
                    if let change = change {
                        if let index = buttons.indexOf(button), let enabled = change[NSKeyValueChangeNewKey] as? Bool {
                            if enabled {
                                button.tintColor = buttonSettings[index].foregroundColor
                                    ?? style!.buttonForegroundColor
                            }
                            else {
                                button.tintColor = buttonSettings[index].disabledColor
                                    ?? style!.buttonDisabledColor
                            }
                        }
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    /**
     Add external open link pattern

     Add URL pattern to open in iOS default behavior.

     - parameters:
        - pattern: String: URL pattern (regular expression)
     
     ex) AppStore's link
     ```
     addExternalLinkPattern("\\/\\/itunes\\.apple\\.com\\/")
     ```
     */
    public func addExternalLinkPattern (pattern: String) -> Self {
        self.externalLinkPattern.append(pattern)
        return self
    }
    
    /**
     Add external open link pattern

     Add URL pattern to open in iOS default behavior with the predefined pattern.

     - parameters:
        - pattern: PTPopupWebViewExternalLinkPattern: the predefined pattern
     */
    
    public func addExternalLinkPattern (pattern: PTPopupWebViewExternalLinkPattern) -> Self {
        self.externalLinkPattern.append(pattern.rawValue)
        return self
    }
    
    /**
     Add button
     
     - parameters:
        - buttonSetting: PTPopupWebViewButton: button setting
     */
    public func addButton (buttonSetting: PTPopupWebViewButton) -> Self {
        self.buttonSettings.append(buttonSetting)
        return self
    }
    
    /// Close popup view
    public func close() {
        if let delegate = delegate {
            // if delegate != nil (ex. when use PTPopupWebViewContoller)
            delegate.close()
        }
        else {
            // if delegate == nil (ex. when use PTPopupWebView directly)
            self.removeFromSuperview()
        }
    }
    
    
    internal func buttonTapped (sender: AnyObject) {
        if let button = sender as? UIButton, let index = buttons.indexOf(button) {
            if index < buttonSettings.count {
                let buttonSetting = buttonSettings[index]
                switch buttonSetting.type {
                case .Close:
                    close()
                case .Link(let url):
                    if let url = url {
                        let request = NSURLRequest(URL: url)
                        webView.loadRequest(request)
                    }
                case .LinkClose(let url):
                    if let url = url {
                        let request = NSURLRequest(URL: url)
                        webView.loadRequest(request)
                    }
                    close()
                case .Back:
                    webView.goBack()
                case .Forward:
                    webView.goForward()
                case .Reload:
                    webView.reload()
                case .Custom:
                    if let handler = buttonSetting.handler {
                        handler()
                    }
                }
            }
        }
    }
    
    
    /// regular expression match
    private func isMatch(string: String, pattern: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        let matches = regex.matchesInString(string, options: [], range:NSMakeRange(0, string.characters.count))
        return matches.count > 0
    }
    
    /// calc button's content width
    private func calcContentWidth(button: UIButton) -> CGFloat {
        var width : CGFloat = 0
        if let labelWidth = button.titleLabel?.sizeThatFits(CGSize(width: CGFloat.max, height: CGFloat.max)).width {
            width += labelWidth
        }
        
        return width
    }
}

extension PTPopupWebView : WKNavigationDelegate {
    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.URL {
            let urlStr = url.absoluteString
            
            for pattern in externalLinkPattern {
                if isMatch(urlStr, pattern: pattern) {
                    UIApplication.sharedApplication().openURL(url)
                    decisionHandler(.Cancel)
                    break
                }
            }
        }
        
        switch (navigationAction.navigationType) {
        case .LinkActivated:
            // if target of a tag is _blank, open in same WKWebView
            if navigationAction.targetFrame == nil {
                if let URL = navigationAction.request.URL {
                    let request = NSURLRequest(URL: URL)
                    webView.loadRequest(request)
                }
            }
            break;
            
        case .FormSubmitted   : break
        case .BackForward     : break
        case .Reload          : break
        case .FormResubmitted : break
        case .Other           : break
        }
        
        decisionHandler(.Allow)
    }
}

public enum PTPopupWebViewExternalLinkPattern : String {
    /// links not starts with "http://","https://"
    case URLScheme = "^(?!https?:\\/\\/)"
    /// iTunes related links
    case iTunes    = "\\/\\/itunes\\.apple\\.com\\/"
}

