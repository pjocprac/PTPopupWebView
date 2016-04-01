//
//  PTPopupWebViewButton.swift
//  PTPopupWebView
//
//  Created by Takeshi Watanabe on 2016/03/19.
//  Copyright © 2016 Takeshi Watanabe. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public enum PTPopupWebViewButtonType {
    /// Button with action of close popup
    case Close
    /// Button with action of open link
    case Link (NSURL?)
    /// Button with action of open link and close popup
    case LinkClose (NSURL?)
    /// Button with action of web navigation of "back"
    case Back
    /// Button with action of web navigation of "forward"
    case Forward
    /// Button with action of web navigation of "reload"
    case Reload
    /// Button with custom action
    case Custom
}

public class PTPopupWebViewButton {
    /* Property */
    public private(set) var type : PTPopupWebViewButtonType = .Close
    public private(set) var title : String = ""
    public private(set) var backgroundColor : UIColor?
    public private(set) var foregroundColor : UIColor?
    public private(set) var disabledColor : UIColor?
    public private(set) var font : UIFont?
    public private(set) var image : UIImage?
    public private(set) var handler : (() -> ())?

    /// Button's title
    public func title (title:String) -> Self {
        self.title = title
        return self
    }

    /// Button's background color
    public func backgroundColor (color:UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    
    /// Button's foreground color
    public func foregroundColor (color:UIColor?) -> Self {
        self.foregroundColor = color
        return self
    }

    /// Button's foreground color when button is disabled
    public func disabledColor (color:UIColor?) -> Self {
        self.disabledColor = color
        return self
    }

    /// Button's font
    public func font (font:UIFont?) -> Self {
        self.font = font
        return self
    }

    /// Button's image
    public func image (image:UIImage?) -> Self {
        self.image = image
        return self
    }

    /// Button's custom action
    public func handler (handler:(() -> ())?) -> Self {
        self.handler = handler
        return self
    }

    /**
     Initializer
     
     - parameters:
        - type  : PTPopupWebViewButtonType
     */
    public init (type: PTPopupWebViewButtonType) {
        self.type = type
    }
    
    /// Set the default image to image property.
    public func useDefaultImage() -> Self {
        var imageName : String? = nil
        switch type {
        case .Close     : imageName = "close"
        case .LinkClose : imageName = "close"
        case .Back      : imageName = "back"
        case .Forward   : imageName = "forward"
        case .Reload    : imageName = "reload"
        default         : break
        }
        
        if let imageName = imageName {
            let bundle = NSBundle(forClass: PTPopupWebViewButton.self)
            let image = UIImage(named: imageName, inBundle: bundle, compatibleWithTraitCollection: nil)
            self.image = image?.imageWithRenderingMode(.AlwaysTemplate)
        }
        
        return self
    }
}