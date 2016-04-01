# Class PTPopupWebViewController
PTPopupWebViewController is UIViewController that wraps the [PTPopupWebView](#PTPopupWebView.md).

The properties, `backgroundStyle`, `transitionStyle`, `popupAppearStyle`, and `popupDisappearStyle` are the additional from [PTPopupWebView](PTPopupWebView.md). By accessing to `popupView` property, it can customize [PTPopupWebView](PTPopupWebView.md)'s style and buttons etc.

The methods, `show()` and `close()` are used to control modal view.

## Usage
PTPopupWebViewController is instantiated with initializer init().
```swift
let popupvc = PTPopupWebViewController()
```

Properties (except popupView property) are able to set by method *propertyName()*.
```swift
popupvc
    .backgroundStyle(.BlurEffect(.Light))
    .transitionStyle(.CrossDissolve)
    .popupAppearStyle(.Slide(.Bottom, 0.4, true))
    .popupDisappearStyle(.Slide(.Top, 0.4, true))
```

Show and close the PTPopupWebViewController are able to be used the methods, `show()` and `close()`.
```swift
// show popup
popupvc.show()

// close popup
popupvc.close()
```


## Properties
All properties are able to set by method chain *propertyName()*.

|Property|Type|Descrption|Default|
|:---|:---|:---|:---|
|backgroundStyle|[PTPopupWebViewControllerBackgroundStyle](#PTPopupWebViewControllerBackgroundStyle)|Background style.|.BlurEffect(.Dark)|
|transitionStyle|[UIModalTransitionStyle](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/#//apple_ref/c/tdef/UIModalTransitionStyle)|Modal Trantision style.|.CrossDissolve|
|popupAppearStyle|[PTPopupWebViewControllerTransitionStyle](#PTPopupWebViewControllerTransitionStyle)|Appearing Transition Style of popup.|.Pop(0.3, true)|
|popupDisappearStyle|[PTPopupWebViewControllerTransitionStyle](#PTPopupWebViewControllerTransitionStyle)|Disappearing Transition Style of popup.|.Pop(0.3, true)|
|popupView|[PTPopupWebView](PTPopupWebView.md)|**[read only property]**<br>Use this property to access PTPopupWebView.||

## Methods
|Method Name|Return Type|Descrption|
|:---|:---|:---|
|show|Void|Show the popup view.|
|close|Void|Close the popup view and dismiss PTPopupWebViewController.|

<a name="PTPopupWebViewControllerBackgroundStyle"></a>
## PTPopupWebViewControllerBackgroundStyle
Enum of PTPopupWebViewControllerBackgroundStyle is defined as below.

|Definition|Arguments|Description|
|:---|:---|:---|
|BlurEffect|[UIBlurEffectStyle](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIBlurEffect_Ref/#//apple_ref/c/tdef/UIBlurEffectStyle)|Blur effect background.|
|Opacity|UIColor?|Opacity background.|
|Transparent||Transparent background.|

<a name="PTPopupWebViewControllerTransitionStyle"></a>
## PTPopupWebViewControllerTransitionStyle
Enum of PTPopupWebViewControllerTransitionStyle is defined as below.

|Definition|Arguments|Description|
|:---|:---|:---|
|Pop|NSTimeInterval, Bool|Transition with pop out/in style **with** content scalling. The argument is animation duration.|
|Spread|NSTimeInterval|Transition with spread out/in style **without** content scalling. The argument is animation duration.|
|Slide|[PTPopupWebViewEffectDirection](#PTPopupWebViewEffectDirection), NSTimeInterval, Bool|Transition with slide in/out effect. First argument is slide direction, second is animation duration, third is to use or not spring effect.|
|Fade|NSTimeInterval|Transition with fade in/out effect. The argument is animation duration.|
|None||Transition without style.|

<a name="PTPopupWebViewEffectDirection"></a>
## PTPopupWebViewEffectDirection
Enum of PTPopupWebViewEffectDirection is defined as below.

|Definition|Description|
|:---|:---|
|Top|Top direction.|
|Bottom|Bottom direction.|
|Left|Top direction.|
|Right|Right direction.|
