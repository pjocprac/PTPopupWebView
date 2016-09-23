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
    case close
    /// Button with action of open link
    case link (URL?)
    /// Button with action of open link and close popup
    case linkClose (URL?)
    /// Button with action of web navigation of "back"
    case back
    /// Button with action of web navigation of "forward"
    case forward
    /// Button with action of web navigation of "reload"
    case reload
    /// Button with custom action
    case custom
}


open class PTPopupWebViewButton {
    /* Property */
    open fileprivate(set) var type : PTPopupWebViewButtonType = .close
    open fileprivate(set) var title : String = ""
    open fileprivate(set) var backgroundColor : UIColor?
    open fileprivate(set) var foregroundColor : UIColor?
    open fileprivate(set) var disabledColor : UIColor?
    open fileprivate(set) var font : UIFont?
    open fileprivate(set) var image : UIImage?
    open fileprivate(set) var handler : (() -> ())?

    /// Button's title
    open func title (_ title:String) -> Self {
        self.title = title
        return self
    }

    /// Button's background color
    open func backgroundColor (_ color:UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    
    /// Button's foreground color
    open func foregroundColor (_ color:UIColor?) -> Self {
        self.foregroundColor = color
        return self
    }

    /// Button's foreground color when button is disabled
    open func disabledColor (_ color:UIColor?) -> Self {
        self.disabledColor = color
        return self
    }

    /// Button's font
    open func font (_ font:UIFont?) -> Self {
        self.font = font
        return self
    }

    /// Button's image
    open func image (_ image:UIImage?) -> Self {
        self.image = image
        return self
    }

    /// Button's custom action
    open func handler (_ handler:(() -> ())?) -> Self {
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
    open func useDefaultImage() -> Self {
        var imageName : String? = nil
        switch type {
        case .close     : imageName = "close"
        case .linkClose : imageName = "close"
        case .back      : imageName = "back"
        case .forward   : imageName = "forward"
        case .reload    : imageName = "reload"
        default         : break
        }
        
        if let imageName = imageName {
            let bundle = Bundle(for: PTPopupWebViewButton.self)
            let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
            self.image = image?.withRenderingMode(.alwaysTemplate)
        }
        
        return self
    }
}
