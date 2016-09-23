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
    case equal
    /// Adjust the width the contents of the button
    case proportional
}

open class PTPopupWebViewStyle {
    // MARK: Content view's property
    open fileprivate(set) var outerMargin : UIEdgeInsets = UIEdgeInsets.zero
    open fileprivate(set) var innerMargin : UIEdgeInsets = UIEdgeInsets.zero
    open fileprivate(set) var backgroundColor : UIColor = .white
    open fileprivate(set) var cornerRadius : CGFloat = 8.0

    // MARK: Content view's property setter
    /// Content view's corner radius (Default: 8.0)
    open func cornerRadius(_ value: CGFloat) -> Self {
        self.cornerRadius = value
        return self
    }

    /// Spacing between frame and content view (Default: UIEdgeInsetsZero)
    open func outerMargin(_ value: UIEdgeInsets) -> Self {
        self.outerMargin = value
        return self
    }

    /// Spacing between content view and web view (Default: UIEdgeInsetsZero)
    open func innerMargin(_ value: UIEdgeInsets) -> Self {
        self.innerMargin = value
        return self
    }

    /// Content view's background color (Default: white color)
    open func backgroundColor(_ value: UIColor) -> Self {
        self.backgroundColor = value
        return self
    }



    // MARK: Title area's property
    open fileprivate(set) var titleHeight : CGFloat = 40.0
    open fileprivate(set) var titleHidden = false
    open fileprivate(set) var titleBackgroundColor : UIColor = .clear
    open fileprivate(set) var titleForegroundColor : UIColor = .darkGray
    open fileprivate(set) var titleFont : UIFont = .systemFont(ofSize: 16)

    // MARK: Title area's property setter
    /// Title area's height (Default: 40.0)
    open func titleHeight(_ value: CGFloat) -> Self {
        self.titleHeight = value;
        return self
    }

    /// Title area's invisibility (Default: false (visible))
    open func titleHidden(_ value: Bool) -> Self {
        self.titleHidden = value
        return self
    }

    /// Title area's background color (Default: clear color)
    open func titleBackgroundColor(_ value: UIColor) -> Self {
        self.titleBackgroundColor = value
        return self
    }

    /// Title area's foreground color (Default: dark gray color)
    open func titleForegroundColor(_ value: UIColor) -> Self {
        self.titleForegroundColor = value
        return self
    }

    /// Title's font (Default: .systemFontOfSize(16))
    open func titleFont(_ value: UIFont) -> Self {
        self.titleFont = value
        return self
    }



    // MARK: Button area's property
    open fileprivate(set) var buttonHeight : CGFloat = 40
    open fileprivate(set) var buttonHidden = false
    open fileprivate(set) var buttonBackgroundColor : UIColor = .clear
    open fileprivate(set) var buttonForegroundColor : UIColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
    open fileprivate(set) var buttonDisabledColor : UIColor = .lightGray
    open fileprivate(set) var buttonFont : UIFont = .systemFont(ofSize: 16)
    open fileprivate(set) var buttonDistribution : PTPopupWebViewButtonDistribution = .equal

    // MARK: Button's property setter
    /// Button area's height (Default: 40.0)
    open func buttonHeight(_ value: CGFloat) -> Self {
        self.buttonHeight = value
        return self
    }

    /// Button area's invisibility (Default: false (visible))
    open func buttonHidden(_ value: Bool) -> Self {
        self.buttonHidden = value
        return self
    }

    /// Button's default background color (Default: clear color)
    /// This setting can be overridden by the button indivisual setting.
    open func buttonBackgroundColor(_ value: UIColor) -> Self {
        self.buttonBackgroundColor = value
        return self
    }

    /// Button's default foreground color (Default: green color, rgb(76,175,80))
    /// This setting can be overridden by the button indivisual setting.
    open func buttonForegroundColor(_ value: UIColor) -> Self {
        self.buttonForegroundColor = value
        return self
    }

    /// Button's default foreground color when button is disabled (Default: light gray color)
    /// This setting can be overridden by the button indivisual setting.
    open func buttonDisabledColor(_ value: UIColor) -> Self {
        self.buttonDisabledColor = value
        return self
    }

    /// Button's font (Default: .systemFontOfSize(16))
    /// This setting can be overridden by the button indivisual setting.
    open func buttonFont(_ value: UIFont) -> Self {
        self.buttonFont = value
        return self
    }

    /// Button's distribution (Default: .Equal, all buttons have equal width)
    open func buttonDistribution(_ value: PTPopupWebViewButtonDistribution) -> Self {
        self.buttonDistribution = value
        return self
    }



    // MARK: Other properties
    open fileprivate(set) var closeButtonHidden = true

    // MARK: Other properties setter
    /// Close button's invisibility (positioned at right top of view) (Default: true (invisible))
    open func closeButtonHidden(_ value: Bool) -> Self {
        self.closeButtonHidden = value
        return self
    }

    // MARK: Initilizer
    public init(){
        // nothing
    }
}

open class PTPopupWebViewControllerStyle : PTPopupWebViewStyle {
    override public init(){
        super.init()
        
        let screenBounds = UIScreen.main.bounds
        let vMargin = screenBounds.height * 0.1
        let hMargin = screenBounds.width  * 0.05
        outerMargin = UIEdgeInsetsMake(vMargin, hMargin, vMargin, hMargin)
    }
}
