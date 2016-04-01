# Class PTPopupWebViewButton
PTPopupWebViewButton is the button settings for [PTPopupWebView](#PTPopupWebView).

## Usage
PTPopupWebViewButton is instantiated with initializer init(type:).
```swift
// button with close action
let button = PTPopupWebViewButton(type: .Close)

// button with open link action
let button = PTPopupWebViewButton(type: .Link(NSURL(string:"https://github.com/")))
```

Properties (except type property) are able to set by method *propertyName()*.
```swift
// button with custom action
let button = PTPopupWebViewButton(type: .Custom)
    .title("Custom Action")
    .backgroundColor(UIColor(red:76/255, green:175/255, blue:80/255, alpha:1))
    .foregroundColor(UIColor.whiteColor())
    .disabledColor(UIColor.lightGrayColor())
    .font(UIFont.boldSystemFontOfSize(16))
    .image(UIImage(named:"demo")?.imageWithRenderingMode(.AlwaysTemplate))
    .handler(){
        print("Demo Action Done!!")
    }
```

Adding a button to PTPopupWebView, use the addButton method.
```swift
let popupvc = PTPopupWebViewController()
let button = PTPopupWebViewButton(type: .Close)
popupvc.popupView.addButton(button);
```

## Properties
Properties (except type property) are able to set by method *propertyName()*.

|Property Name|Type|Descrption|Default|
|:---|:---|:---|:---|
|type|[PTPopupWebViewButtonType](#PTPopupWebViewButtonType)|Button's type, to specify by initializer init(type:).||
|title|String|Button's title.|""|
|backgroundColor|UIColor?|Button's background color.||
|foregroundColor|UIColor?|Button's foreground color.||
|disabledColor|UIColor?|Button's foreground color when button is disabled||
|font|UIFont?|Button's font||
|image|UIImage?|Button's custom image||
|handler|(() -> ())?|Button's custom action. If the botton (type .Custom) is tappped, this handler will be called.||

## Methods
|Method Name|Return Type|Descrption|
|:---|:---|:---|
|useDefaultImage|Self|Set the default image to image property.|

<a name="PTPopupWebViewButtonType"></a>
## PTPopupWebViewButtonType
Enum of PTPopupWebViewButtonType is defined as below.

|Definition|Arguments|Description|
|:---|:---|:---|
|Close||Button with action of close popup.|
|Link|NSURL?|Button with action of open link.|
|LinkClose|NSURL?|Button with action of open link and close popup.|
|Back||Button with action of web navigation of "back".|
|Forward||Button with action of web navigation of "forward".|
|Reload||Button with action of web navigation of "reload".|
|Custom||Button with custom action.|
