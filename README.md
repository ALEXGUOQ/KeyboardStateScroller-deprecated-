## Description

KeyboardStateScroller is a keyboard listener that will scroll any UIView up if the keyboard is being shown, and vice versa.
Two views are registered with KeyboardStateScroller, a scrollingView and a targetView.  If the targetView's frame is going to be obscured but the keyboard, then the scrollingView will be scrolled up.

## Features:

KeyboardStateScroller works with iPhone and iPad keyboards and accommodates split and undocked iPad keyboard states in all orentations

## How to use:

To register a view to scroll
```objective-c
[IHKeyboardStateListener registerViewToScroll:(UIView *)scrollingView with:(UIView *)targetView];
```

Parameters
```(UIView *)scrollingView```   The view to scroll, usually the background view
```(UIView *)targetView```      If this targetView's frame is going to be intersected by the keyboard, then the scrollingView will be scrolled.  If this view is going to be obscured by the keyboard, then scrollView will scroll up with the keyboard.

Other methods
```(BOOL)isKeyboardVisible```   A utility method to find out if the keyboard is visible
```(void)setBuffer:(int)buffer``` Scrolling will be triggered if the keyboard is withing [buffer] points of the targetView's frame.  Default buffer is 30.

## Restrictions:

KeyboardStateScroller doesn't play nice with AutoLayout's vertical constraints
Only one scrollingView and targetView can be registered at a time.

## Author

* Fraser Scott-Morrison (lasereraser@gmail.com)

## Do To:

* Improve demo project
* Add secondary scrolling technique: minimize scrolling so that focusView is left sitting on top of keyboard
