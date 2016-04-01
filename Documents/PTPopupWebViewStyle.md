# Class PTPopupWebViewStyle
PTPopupWebViewStyle is view style settings for PTPopupWebView.

To customize the style, you choose one of below way.

1. generate a PTPopupWebViewStyle instance and change the parameters.
2. define the Style class extends PTPopupWebViewStyle, and change the parameters in initializer.

## Usage
Generate a PTPopupWebViewStyle instance and change the parameters,
```swift
let style = PTPopupWebViewStyle()
    .titleBackgroundColor(.darkGrayColor())
    .titleForegroundColor(.whiteColor())
```
or define the Style class extends PTPopupWebViewStyle, and change the parameters in initializer as below.
```swift
public class MyStyle : PTPopupWebViewStyle {
    override public init(){
        super.init()
        
        titleBackgroundColor = .darkGrayColor()
        titleForegroundColor = .whiteColor()
    }
}
```

## Property
All properties are able to set by method chain *propertyName()*.

### Content view's property
|Property|Descrption|Default|
|:---|:---|:---|
|outerMargin|Spacing between frame and content view.|UIEdgeInsetsZero|
|innerMargin|Spacing between content view and web view.|UIEdgeInsetsZero|
|backgroundColor|Content view's background color.|UIColor.whiteColor()|
|cornerRadius|Content view's corner radius.|8.0|

### Title area's property
|Property|Descrption|Default|
|:---|:---|:---|
|titleHeight|Title area's height.|40.0|
|titleHidden|Title area's invisibility.|false|
|titleBackgroundColor|Title area's background color.|UIColor.clearColor()|
|titleForegroundColor|Title area's foreground color.|UIColor.darkGrayColor()|
|titleFont|Title's font.|UIFont.systemFontOfSize(16)|

### Button area's property
|Property|Descrption|Default|
|:---|:---|:---|
|buttonHeight|Button area's height.|40|
|buttonHidden|Button area's invisibility.|false|
|buttonBackgroundColor|Button's default background color. [※](#annotation)|UIColor.clearColor()|
|buttonForegroundColor|Button's default foreground color. [※](#annotation)|green color|
|buttonDisabledColor|Button's default foreground color when button is disabled. [※](#annotation)|UIColor.lightGrayColor()|
|buttonFont|Button's font. [※](#annotation)|UIFont.systemFontOfSize(16)|
|buttonDistribution|Button's distribution. .Equal, all buttons have equal width, .Proportional, adjust the width the contents of the button.|.Equal|

<a name="annotation"></a>※ These settings can be overridden by the button indivisual settings.

### Other property
|Property|Descrption|Default|
|:---|:---|:---|
|closeButtonHidden|Close button's invisibility (positioned at right top of view).|true|
