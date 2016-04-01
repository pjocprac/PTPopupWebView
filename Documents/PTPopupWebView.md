# Class PTPopupWebView
PTPopupWebView is UIView contains webview, title, and buttons.

Appearance of view can be changed by style class, [PTPopupWebViewStyle](PTPopupWebViewStyle.md).

The button's style and action can be changed by setting class [PTPopupWebViewButton](PTPopupWebViewButton.md). Also, button's action can be changed, the web navigations which is predefined actions, and the custom action can use.

## Usage
PTPopupWebView is instantiated with initializer init(), or access to [PTPopupWebViewController](PTPopupWebViewController.md)'s property `popupView`
```swift
let popupView = PTPopupWebView()
// or
let popupvc = PTPopupWebViewController()
let popupView = popupvc.popupView
```

All properties are able to set by method chain *propertyName()*.
```swift
popupView
    .URL(NSURL(string: "https://github.com/"))
    .style(style)
```

The method `addExternalLinkPattern()` is used to add URL pattern to open in iOS default behavior, and the method `addButton()` is used to add buttons.
```swift
popupView
    .addExternalLinkPattern(.iTunes)
    .addExternalLinkPattern("^test:\\/\\/")
    .addButton(button)
```

Show PTPopupWebView are able to be added to view when directly use PTPopupWebView, or [PTPopupWebViewController](PTPopupWebViewController.md)'s method `show()`. And close are able to be used the method `close()`.
```swift
// show popup
view.addSubview(popupView) // directly use PTPopupWebView
// or
popupvc.show()

// close popup
popup.close()
```

## Properties
All properties are able to set by method chain *propertyName()*.

|Property|Descrption|Default|
|:---|:---|:---|
|URL|URL of the page you want to display.||
|title|The specified title instead of web page's title. If valuse is set nil, displays web page's title.||
|content|The specified contents instead of web resources.||
|style|View style. Detail of style parameter, see [PTPopupWebViewStyle](#PTPopupWebViewStyle).||

## Methods
|Method Name|Arguments|Return Type|Descrption|
|:---|:---|:---|:---|
|addExternalLinkPattern|String|Self|Add URL pattern to open in iOS default behavior.|
|addExternalLinkPattern|[PTPopupWebViewExternalLinkPattern](#PTPopupWebViewExternalLinkPattern)|Self|Add URL pattern to open in iOS default behavior.|
|addButton|[PTPopupWebViewButton](PTPopupWebViewButton.md)|Self|Add button to popupView|
|close||Void|Close the popup view.|

<a name="PTPopupWebViewExternalLinkPattern"></a>
## PTPopupWebViewExternalLinkPattern
Enum of PTPopupWebViewExternalLinkPattern is defined as below.

|Definition|Value|Description|
|:---|:---|:---|
|URLScheme|"^(?!https?:\\/\\/)"|links not starts with "http://","https://"|
|iTunes|"\\/\\/itunes\\.apple\\.com\\/"|iTunes related links|

