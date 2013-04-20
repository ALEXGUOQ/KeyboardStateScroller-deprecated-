## Description

KeyboardStateScroller is a keyboard listener that will scroll any UIView up if the keyboard is being shown, or vice versa

## Features:

KeyboardStateScroller works with iPhone and iPad keyboards and accommodates split and undocked iPad keyboard states

## How to use:

To register a view to scroll, call 
```objective-c
[IHKeyboardStateListener registerViewToScroll:focusView scrollingView:scrollingView];
```

parameters
```objective-c(UIView *)scrollingView```   The view to scroll, usually to background view
```objective-c(UIView *)focusView```       This view's location determines whether the scrollingView is scrolled.  If this view is going to be obscured by the keyboard, then scrollView will scroll up with the keyboard.

## Restrictions:

KeyboardStateScroller doesn't play nice with AutoLayout's vertical constraints

## Author

* Fraser Scott-Morrison (lasereraser@gmail.com)

## Do To:

* Improve demo project
* Make buffer & isKeyBoardVisible properties visible
* Add secondary scrolling technique: minimize scrolling so that focusView is left sitting on top of keyboard