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

open class PTPopupWebView : UIView {
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
    open fileprivate(set) var webView = WKWebView()


    /* Property */
    
    /// Title text
    open fileprivate(set) var title : String? {
        didSet {
            self.titleLabel?.text = title
        }
    }
    /// URL
    open fileprivate(set) var URL : Foundation.URL? {
        didSet {
            if let URL = URL {
                let request = URLRequest(url: URL)
                webView.load(request)
            }
        }
    }
    /// Content
    open fileprivate(set) var content : String? {
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
    open fileprivate(set) var style : PTPopupWebViewStyle?

    /**
     Title text.
     If valuse is nil, displays web page's title.
     If you want to specify the title text instead of web page's title, set this paramaeter.

     -parameters:
        - title: title text
     */
    open func title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    
    /**
     URL

     - parameters:
        - URL: URL
     */
    open func URL(_ URL: Foundation.URL?) -> Self {
        self.URL = URL
        return self
    }
    /**
     URL

     - parameters:
        - string: URL string
     */
    open func URL(string urlString: String) -> Self {
        URL(Foundation.URL(string: urlString))
        return self
    }

    

    /**
     Webview's contents text.
     If you want to specify the display contents in the text instead of Web resources, set this parameter.
     
     - parameters:
        - content: contents text
     */
    open func content(_ content: String?) -> Self {
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
    open func style(_ style: PTPopupWebViewStyle) -> Self {
        self.style = style
        return self
    }




    /// External link patterns (open with iOS system)
    open fileprivate(set) var externalLinkPattern : [String] = []
    
    /// button settings
    fileprivate var buttonSettings : [PTPopupWebViewButton] = []
    
    /// UIButtons
    fileprivate var buttons : [UIButton] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    fileprivate func loadView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PTPopupWebView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        addSubview(view)

        // Add KeyValue observer for webview
        webView.addObserver(self, forKeyPath:"title", options:.new, context:nil)
        webView.addObserver(self, forKeyPath:"URL", options:.new, context:nil)
        webView.addObserver(self, forKeyPath:"load" , options:.new, context:nil)
        webView.addObserver(self, forKeyPath:"estimatedProgress" , options:.new, context:nil)
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
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
        titleView.isHidden = style.titleHidden
        titleViewHeight.constant = style.titleHeight

        if style.titleHidden {
            innerMarginTop.constant -= titleView.bounds.height
        }
        
        buttonContainer.isHidden = style.buttonHidden
        if style.buttonHidden {
            innerMarginBottom.constant -= buttonContainer.bounds.height
        }
        else {
            buttonContainerHeight.constant = style.buttonHeight
        }
        
        // Button initialize
        // if not exists button settings, add default button ('close' button)
        if buttonSettings.count == 0 {
            buttonSettings.append(PTPopupWebViewButton(type: .close).title("close"))
        }
        for buttonSetting in buttonSettings {
            let button = UIButton()
            button.titleLabel?.font = buttonSetting.font ?? style.buttonFont
            button.setTitle(buttonSetting.title, for: UIControlState())
            button.setTitleColor(buttonSetting.foregroundColor ?? style.buttonForegroundColor, for: UIControlState())
            button.setTitleColor(buttonSetting.disabledColor ?? style.buttonDisabledColor, for: .disabled)
            button.backgroundColor = buttonSetting.backgroundColor ?? style.buttonBackgroundColor
            button.setImage(buttonSetting.image, for: UIControlState())
            
            // Forward/Back/Reload's initial state is disabled
            switch buttonSetting.type {
            case .forward, .back, .reload:
                button.isEnabled = false
                button.tintColor = buttonSetting.disabledColor ?? style.buttonDisabledColor
            default:
                button.tintColor = buttonSetting.foregroundColor ?? style.buttonForegroundColor
            }
            
            // observe enabled property for coloring
            button.addObserver(self, forKeyPath:"enabled", options:.new, context:nil)
            
            
            button.adjustsImageWhenHighlighted = false
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(PTPopupWebView.buttonTapped(_:)), for: .touchUpInside)
            buttonContainer.addSubview(button)
            buttons.append(button)
        }

        // add constraints for buttons
        for i in 0 ..< buttons.count {
            let button = buttons[i]
            // Top/Bottom to container is 0
            for attribute in [NSLayoutAttribute.top, NSLayoutAttribute.bottom] {
                buttonContainer.addConstraint(
                    NSLayoutConstraint(
                        item  : button,          attribute: attribute, relatedBy: NSLayoutRelation.equal,
                        toItem: buttonContainer, attribute: attribute, multiplier: 1.0, constant: 0.0)
                )
            }
            
            // Leading constraint
            let leftItem      = i == 0 ? buttonContainer : buttons[i - 1]
            let leftAttribute = i == 0 ? NSLayoutAttribute.leading : NSLayoutAttribute.trailing
            buttonContainer.addConstraint(
                NSLayoutConstraint(
                    item  : button,   attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal,
                    toItem: leftItem, attribute: leftAttribute, multiplier: 1.0, constant: 0.0)
            )
            
            // Trailing constraint
            let rightItem      = i == buttons.count - 1 ? buttonContainer : buttons[i + 1]
            let rightAttribute = i == buttons.count - 1 ? NSLayoutAttribute.trailing : NSLayoutAttribute.leading
            buttonContainer.addConstraint(
                NSLayoutConstraint(
                    item  : button,    attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal,
                    toItem: rightItem, attribute: rightAttribute, multiplier: 1.0, constant: 0.0)
            )
        }

        switch style.buttonDistribution {
        case .equal:
            // Equal width constraints
            for i in 1 ..< buttons.count {
                buttonContainer.addConstraint(
                    NSLayoutConstraint(
                        item  : buttons[0], attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal,
                        toItem: buttons[i], attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)
                )
            }
            
        case .proportional:
            // Equal width constraints with constant, is difference of buttons content's width
            let baseWidth = calcContentWidth(buttons[0])
            for i in 1 ..< buttons.count {
                let diffWidth = baseWidth - calcContentWidth(buttons[i])
                buttonContainer.addConstraint(
                    NSLayoutConstraint(
                        item  : buttons[0], attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal,
                        toItem: buttons[i], attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: diffWidth)
                )
            }
        }
        
        // Close button
        closeButton.isHidden = style.closeButtonHidden
        if !style.closeButtonHidden {
            let bundle = Bundle(for: PTPopupWebViewButton.self)
            let image = UIImage(named: "close", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            
            closeButton.setImage(image, for: UIControlState())
            closeButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
            closeButton.addTarget(self, action: #selector(PTPopupWebView.close), for: .touchUpInside)
        }

        // Web view
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)
        for attribute in [NSLayoutAttribute.top, NSLayoutAttribute.leading, NSLayoutAttribute.bottom, NSLayoutAttribute.trailing] {
            webViewContainer.addConstraint(
                NSLayoutConstraint(
                    item  : webViewContainer, attribute: attribute, relatedBy: NSLayoutRelation.equal,
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
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is WKWebView {
            if let keyPath = keyPath {
                switch keyPath {
                case "title":
                    if title == nil {
                        if let change = change {
                            titleLabel.text = change[NSKeyValueChangeKey.newKey] as? String
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
                        case .back    :
                            // To enable the Back button, when there is history.
                            buttons[i].isEnabled = webView.canGoBack
                        case .forward :
                            // To enable the Forward button, when there is advance history.
                            buttons[i].isEnabled = webView.canGoForward
                        case .reload  :
                            // To enable the update button, after completion of reading.
                            if let change = change, let progress = change[NSKeyValueChangeKey.newKey] as? Double {
                                buttons[i].isEnabled = progress == 1.0
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
                        if let index = buttons.index(of: button), let enabled = change[NSKeyValueChangeKey.newKey] as? Bool {
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
    open func addExternalLinkPattern (_ pattern: String) -> Self {
        self.externalLinkPattern.append(pattern)
        return self
    }
    
    /**
     Add external open link pattern

     Add URL pattern to open in iOS default behavior with the predefined pattern.

     - parameters:
        - pattern: PTPopupWebViewExternalLinkPattern: the predefined pattern
     */
    
    open func addExternalLinkPattern (_ pattern: PTPopupWebViewExternalLinkPattern) -> Self {
        self.externalLinkPattern.append(pattern.rawValue)
        return self
    }
    
    /**
     Add button
     
     - parameters:
        - buttonSetting: PTPopupWebViewButton: button setting
     */
    open func addButton (_ buttonSetting: PTPopupWebViewButton) -> Self {
        self.buttonSettings.append(buttonSetting)
        return self
    }
    
    /// Close popup view
    @objc open func close() {
        if let delegate = delegate {
            // if delegate != nil (ex. when use PTPopupWebViewContoller)
            delegate.close()
        }
        else {
            // if delegate == nil (ex. when use PTPopupWebView directly)
            self.removeFromSuperview()
        }
    }
    
    
    @objc internal func buttonTapped (_ sender: AnyObject) {
        if let button = sender as? UIButton, let index = buttons.index(of: button) {
            if index < buttonSettings.count {
                let buttonSetting = buttonSettings[index]
                switch buttonSetting.type {
                case .close:
                    close()
                case .link(let url):
                    if let url = url {
                        let request = URLRequest(url: url)
                        webView.load(request)
                    }
                case .linkClose(let url):
                    if let url = url {
                        let request = URLRequest(url: url)
                        webView.load(request)
                    }
                    close()
                case .back:
                    webView.goBack()
                case .forward:
                    webView.goForward()
                case .reload:
                    webView.reload()
                case .custom:
                    if let handler = buttonSetting.handler {
                        handler()
                    }
                }
            }
        }
    }
    
    
    /// regular expression match
    fileprivate func isMatch(_ string: String, pattern: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex.matches(in: string, options: [], range:NSMakeRange(0, string.characters.count))
        return matches.count > 0
    }
    
    /// calc button's content width
    fileprivate func calcContentWidth(_ button: UIButton) -> CGFloat {
        var width : CGFloat = 0
        if let labelWidth = button.titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width {
            width += labelWidth
        }
        
        return width
    }
}

extension PTPopupWebView : WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let urlStr = url.absoluteString
            
            for pattern in externalLinkPattern {
                if isMatch(urlStr, pattern: pattern) {
                    UIApplication.shared.openURL(url)
                    decisionHandler(.cancel)
                    break
                }
            }
        }
        
        switch (navigationAction.navigationType) {
        case .linkActivated:
            // if target of a tag is _blank, open in same WKWebView
            if navigationAction.targetFrame == nil {
                if let URL = navigationAction.request.url {
                    let request = URLRequest(url: URL)
                    webView.load(request)
                }
            }
            break;
            
        case .formSubmitted   : break
        case .backForward     : break
        case .reload          : break
        case .formResubmitted : break
        case .other           : break
        }
        
        decisionHandler(.allow)
    }
}

public enum PTPopupWebViewExternalLinkPattern : String {
    /// links not starts with "http://","https://"
    case URLScheme = "^(?!https?:\\/\\/)"
    /// iTunes related links
    case iTunes    = "\\/\\/itunes\\.apple\\.com\\/"
}

