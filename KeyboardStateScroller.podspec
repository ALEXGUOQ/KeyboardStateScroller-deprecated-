#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'KeyboardStateScroller'
  s.version          = '0.1.0'
  s.summary          = 'KeyboardStateScroller is a keyboard listener that will scroll any UIView up if the keyboard is being shown, and vice versa'
  s.description      = <<-DESC
                       Two views are registered with KeyboardStateScroller, a scrollingView and a targetView.  If the targetView's frame will be intersected by the keyboard, then the scrollingView will be scrolled up the same distance and speed as the keyboard

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = 'http://www.postar.me'
  s.license          = 'MIT'
  s.author           = { 'Fraser Scott-Morrison' => 'fraserscottmorrison@me.com' }
  s.source           = { :git => 'https://github.com/IdleHandsApps/KeyboardStateScroller.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.source_files = 'Classes'
  s.public_header_files = 'Classes/*.h'

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.requires_arc = true

end
