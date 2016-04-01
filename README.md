# PTPopupWebView

[![Version](https://img.shields.io/cocoapods/v/PTPopupWebView.svg?style=flat)](http://cocoapods.org/pods/PTPopupWebView)
[![License](https://img.shields.io/cocoapods/l/PTPopupWebView.svg?style=flat)](http://cocoapods.org/pods/PTPopupWebView)
[![Platform](https://img.shields.io/cocoapods/p/PTPopupWebView.svg?style=flat)](http://cocoapods.org/pods/PTPopupWebView)

PTPopupWebView is a simple and useful WebView for iOS, which can be popup and has many of the customized item.
![Pop](https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/style_pop.gif "Pop")

## Requirement
iOS 8.0

## Installation

PTPopupWebView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
use_frameworks!
pod "PTPopupWebView"
```

## Usage
To use this library, there are two ways,

1. Use [PTPopupWebViewController](Documents/PTPopupWebViewController.md), this is simple when use as modal popup.
2. Directly use [PTPopupWebView](Documents/PTPopupWebView.md).

Details, see the Demo and the [Class Reference](#ClassReference).

<a name="ClassReference"></a>
## Class Reference
[Class Reference](Documents/README.md)

## Demo
To run the example project, clone the repo, and run `pod install` from the Example directory first.

#### Introduction
At first, to popup webpage is only code below.
```
let popupvc = PTPopupWebViewController()
popupvc.popupView.URL(string: "https://github.com/")
popupvc.show()
```

<a name="PopupTransitionStyle"></a>
#### Popup Transition Style
<a name ="pos1"></a>
Popup Appear/Disappear Style can be changed as below.

```swift
// Pop Style (default transition style. 1st parameter is animation duration, and 2nd is using spring animation flag.)
let popupvc = PTPopupWebViewController()
    .popupAppearStyle(.Slide(.Bottom, 0.4, true))
    .popupDisappearStyle(.Slide(.Bottom, 0.4, true))
```

```swift
// Spread Style (parameter is animation duration)
let popupvc = PTPopupWebViewController()
    .popupAppearStyle(.Spread(0.25))
    .popupDisappearStyle(.Spread(0.25))
```

```swift
// Slide Style (1st parameter is direction, 2nd is animation duration, and 3rd is using spring animation flag.)
let popupvc = PTPopupWebViewController()
    .popupAppearStyle(.Slide(.Bottom, 0.4, true))
    .popupDisappearStyle(.Slide(.Bottom, 0.4, true))
```

```swift
// Fade Style (parameter is animation duration)
let popupvc = PTPopupWebViewController()
    .popupAppearStyle(.Fade(0.25))
    .popupDisappearStyle(.Fade(0.25))
```

```swift
// Without Transition Style
let popupvc = PTPopupWebViewController()
    .popupAppearStyle(.None)
    .popupDisappearStyle(.None)
```

|Pop|Spread|Slide|
|---|---|---|
|![Pop](https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/style_pop.gif "Pop")|![Spread](https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/style_spread.gif "Spread")|![Slide](https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/style_slide.gif "Slide")|

|Fade|None|
|---|---|
![Fade](https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/style_fade.gif "Fade")|![Introduction](https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/style_none.gif "None")|

#### Custom Action 
Custom action button can do user defined action with PTPopupWebViewButton's handler property.
```swift
popupvc.popupView
    // add custom action button
    .addButton(
        PTPopupWebViewButton(type: .Custom)
            .title("custom"))
            .handler() {
                // write handler code here

                // this demo show alert view
                let alert:UIAlertController = UIAlertController(title: "Custom Action",message: popupvc.popupView.webView.title!,preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                popupvc.presentViewController(alert, animated: true, completion: nil)
            }
    // add close button
    .addButton(PTPopupWebViewButton(type: .Close).title("close"))
popupvc.show()
```

|Custom Action|
|---|
|![Custom Action](https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/custom_action.gif "Custom Action")|


#### View Style
Details code reference to the source code of the demo application.

##### Title Style
|Colored Title|Hide Title|
|---|---|
|<img src="https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/colored_title.png" width="240" alt="Colored Title">|<img src="https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/hide_title.png" width="240" alt="Hide Title">|

##### Button Style
|Colored Button|Custom Image Button|Hide Button|
|---|---|---|
|<img src="https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/colored_button.png" width="240" alt="Colored Button">|<img src="https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/custom_image_button.png" width="240" alt="Custom Image Button">|<img src="https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/hide_button.png" width="240" alt="Hide Button">|

##### Other Style
|FullScreen|With Frame|
|---|---|
|<img src="https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/fullscreen.png" width="240" alt="FullScreen">|<img src="https://raw.githubusercontent.com/pjocprac/PTPopupWebView/master/Images/with_frame.png" width="240" alt="With Frame">|

## Author

Takeshi Watanabe, watanabe@tritrue.com

## License

PTPopupWebView is available under the MIT license. See the LICENSE file for more info.
