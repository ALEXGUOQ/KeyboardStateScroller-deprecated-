
An elegant solution for keeping any UIView visible when the keyboard is being shown

## Description

KeyboardStateScroller is a keyboard listener that will translate any UIView up if the keyboard is being shown, and vice versa.  
Two views are registered with KeyboardStateScroller, the UIView to translate and one or more target UIViews.  If a targetView's frame will be intersected by the keyboard, then the translating View will animate up just above the keyboard.

Although called a scroller, no UIScrollView is used. If Autolayout is used then the constraints are animated, otherwise a CGAffine translation is done.

## Features:

KeyboardStateScroller works with iPhone and iPad keyboards and accommodates split and undocked iPad keyboard states in all orentations

## How to use:

To set a view to scroll
```objective-c
[IHKeyboardStateListener setViewToScroll:(UIView *)scrollingView with:(UIView *)targetView];
```
To add another target
[IHKeyboardStateListener addTarget:(UIView *)targetView];
```

Parameters   
```(UIView *)scrollingView```   The view to scroll, usually the background view
```(UIView *)targetView```      If a targetView's frame will be intersected by the keyboard, then the scrollingView will be scrolled.

Optional methods    
```(BOOL)isKeyboardVisible```   A convenience method to check if the keyboard is visible  
```(void)setBuffer:(int)buffer``` Scrolling will be triggered if the keyboard is within [buffer] points of the targetView's frame.  Default buffer is 0
```(void)setScrollPadding:(int)buffer``` The padding to put between the keyboard and scrolling view.  Default padding is 0
## Similar Keyboard avoiding solutions:

https://github.com/michaeltyson/TPKeyboardAvoiding (UIScrollView based)
https://github.com/kirpichenko/EKKeyboardAvoiding (UIScrollView based)
https://github.com/robbdimitrov/RDVKeyboardAvoiding (UIScrollView based)
https://github.com/danielamitay/DAKeyboardControl (looks interesting)

## Author

* Fraser Scott-Morrison (fraserscottmorrison@me.com)

## Do To:

* Improve demo project
* Gif demo
