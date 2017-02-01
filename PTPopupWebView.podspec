#
# Be sure to run `pod lib lint PTPopupWebView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PTPopupWebView"
  s.version          = "0.4.0"
  s.summary          = "Swift subclass of the UIView which provide Popup web view."
  s.homepage         = "https://github.com/pjocprac/PTPopupWebView.git"
  s.license          = 'MIT'
  s.author           = { "Takeshi Watanabe" => "watanabe@tritrue.com" }
  s.source           = { :git => "https://github.com/pjocprac/PTPopupWebView.git", :branch => 'master', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.resources    = "Pod/Assets/**/*.png", "Pod/Assets/**/*.xib"
end
