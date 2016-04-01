//
//  PTPopupWebViewStyle.swift
//  PTPopupWebView
//
//  Created by Takeshi Watanabe on 2016/03/19.
//  Copyright © 2016 Takeshi Watanabe. All rights reserved.
//

import Foundation

public enum PTPopupWebViewButtonDistribution {
    /// All buttons have equal width
    case Equal
    /// Adjust the width the contents of the button
    case Proportional
}

public class PTPopupWebViewStyle {
    // MARK: Content view's property
    public private(set) var outerMargin : UIEdgeInsets = UIEdgeInsetsZero
    public private(set) var innerMargin : UIEdgeInsets = UIEdgeInsetsZero
    public private(set) var backgroundColor : UIColor = .whiteColor()
    public private(set) var cornerRadius : CGFloat = 8.0

    // MARK: Content view's property setter
    /// Content view's corner radius (Default: 8.0)
    public func cornerRadius(value: CGFloat) -> Self {
        self.cornerRadius = value
        return self
    }

    /// Spacing between frame and content view (Default: UIEdgeInsetsZero)
    public func outerMargin(value: UIEdgeInsets) -> Self {
        self.outerMargin = value
        return self
    }

    /// Spacing between content view and web view (Default: UIEdgeInsetsZero)
    public func innerMargin(value: UIEdgeInsets) -> Self {
        self.innerMargin = value
        return self
    }

    /// Content view's background color (Default: white color)
    public func backgroundColor(value: UIColor) -> Self {
        self.backgroundColor = value
        return self
    }



    // MARK: Title area's property
    public private(set) var titleHeight : CGFloat = 40.0
    public private(set) var titleHidden = false
    public private(set) var titleBackgroundColor : UIColor = .clearColor()
    public private(set) var titleForegroundColor : UIColor = .darkGrayColor()
    public private(set) var titleFont : UIFont = .systemFontOfSize(16)

    // MARK: Title area's property setter
    /// Title area's height (Default: 40.0)
    public func titleHeight(value: CGFloat) -> Self {
        self.titleHeight = value;
        return self
    }

    /// Title area's invisibility (Default: false (visible))
    public func titleHidden(value: Bool) -> Self {
        self.titleHidden = value
        return self
    }

    /// Title area's background color (Default: clear color)
    public func titleBackgroundColor(value: UIColor) -> Self {
        self.titleBackgroundColor = value
        return self
    }

    /// Title area's foreground color (Default: dark gray color)
    public func titleForegroundColor(value: UIColor) -> Self {
        self.titleForegroundColor = value
        return self
    }

    /// Title's font (Default: .systemFontOfSize(16))
    public func titleFont(value: UIFont) -> Self {
        self.titleFont = value
        return self
    }



    // MARK: Button area's property
    public private(set) var buttonHeight : CGFloat = 40
    public private(set) var buttonHidden = false
    public private(set) var buttonBackgroundColor : UIColor = .clearColor()
    public private(set) var buttonForegroundColor : UIColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
    public private(set) var buttonDisabledColor : UIColor = .lightGrayColor()
    public private(set) var buttonFont : UIFont = .systemFontOfSize(16)
    public private(set) var buttonDistribution : PTPopupWebViewButtonDistribution = .Equal

    // MARK: Button's property setter
    /// Button area's height (Default: 40.0)
    public func buttonHeight(value: CGFloat) -> Self {
        self.buttonHeight = value
        return self
    }

    /// Button area's invisibility (Default: false (visible))
    public func buttonHidden(value: Bool) -> Self {
        self.buttonHidden = value
        return self
    }

    /// Button's default background color (Default: clear color)
    /// This setting can be overridden by the button indivisual setting.
    public func buttonBackgroundColor(value: UIColor) -> Self {
        self.buttonBackgroundColor = value
        return self
    }

    /// Button's default foreground color (Default: green color, rgb(76,175,80))
    /// This setting can be overridden by the button indivisual setting.
    public func buttonForegroundColor(value: UIColor) -> Self {
        self.buttonForegroundColor = value
        return self
    }

    /// Button's default foreground color when button is disabled (Default: light gray color)
    /// This setting can be overridden by the button indivisual setting.
    public func buttonDisabledColor(value: UIColor) -> Self {
        self.buttonDisabledColor = value
        return self
    }

    /// Button's font (Default: .systemFontOfSize(16))
    /// This setting can be overridden by the button indivisual setting.
    public func buttonFont(value: UIFont) -> Self {
        self.buttonFont = value
        return self
    }

    /// Button's distribution (Default: .Equal, all buttons have equal width)
    public func buttonDistribution(value: PTPopupWebViewButtonDistribution) -> Self {
        self.buttonDistribution = value
        return self
    }



    // MARK: Other properties
    public private(set) var closeButtonHidden = true

    // MARK: Other properties setter
    /// Close button's invisibility (positioned at right top of view) (Default: true (invisible))
    public func closeButtonHidden(value: Bool) -> Self {
        self.closeButtonHidden = value
        return self
    }

    // MARK: Initilizer
    public init(){
        // nothing
    }
}

public class PTPopupWebViewControllerStyle : PTPopupWebViewStyle {
    override public init(){
        super.init()
        
        let screenBounds = UIScreen.mainScreen().bounds
        let vMargin = screenBounds.height * 0.1
        let hMargin = screenBounds.width  * 0.05
        outerMargin = UIEdgeInsetsMake(vMargin, hMargin, vMargin, hMargin)
    }
}