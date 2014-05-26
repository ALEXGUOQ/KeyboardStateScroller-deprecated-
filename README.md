
An elegant solution for keeping any UIView visible when the keyboard is being shown

## Description

IHKeyboardAvoiding will translate any UIView up when the keyboard is being shown, then return it when the keyboard is hidden.  
Two views are registered with IHKeyboardAvoiding, the 'avoiding' UIView to translate and one or more 'target' UIViews.  If a target view's frame will be intersected by the keyboard, then the avoiding view will move up just above the keyboard.

No UIScrollView is used. If Autolayout is used then the constraints are animated, otherwise a CGAffine translation is done.

## Supported Features:

* iPhone keyboard
* iPad docked keyboard
* iPad undocked keyboard
* iPad split keyboard
* landscape & protrait
* autolayout
* traditional layout

## How to use:

To set the view to move
```objective-c
[IHKeyboardAvoiding setAvoidingView:(UIView *)avoidingView with:(UIView *)targetView];
```
To add another target
```objective-c
[IHKeyboardAvoiding addTarget:(UIView *)targetView];
```

Parameters   
```(UIView *)avoidingView```   The view to move above the keyboard, usually the background view  
```(UIView *)targetView```      If a targetView's frame will be intersected by the keyboard, then the avoidingView will be moved.

Optional methods    
```(BOOL)isKeyboardVisible```   A convenience method to check if the keyboard is visible  
```(void)setBuffer:(int)buffer``` Avoiding will be triggered if the keyboard is within [buffer] points of the targetView's frame.  Default buffer is 0  
```(void)setPadding:(int)buffer``` The padding to put between the keyboard and avoiding view.  Default padding is 0
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
