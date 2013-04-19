KeyboardStateScroller
=====================

A keyboard listener that will scroll any UIView up if the keyboard is being shown, or vice versa

Features:
=========
KeyboardStateScroller works with iPhone and iPad keyboards and accommodates split and undocked iPad keyboard states


How to use:
==========

To register a view to scroll, call [IHKeyboardStateListener registerViewToScroll:focusView scrollingView:scrollingView]

parameters
(UIView *)scrollingView   The view to scroll, usually to background view
(UIView *)focusView       This view's location determines whether the scrollingView is scrolled.  If this view is going to be obscured by the keyboard, then scrollView will scroll up with the keyboard.


Restrictions:
=============
KeyboardStateScroller doesn't play nice with AutoLayout's vertical constraints


Do To:
======
Improve demo project
Make buffer & isKeyBoardVisible properties visible
Add secondary scrolling technique: minimize scrolling so that focusView is left sitting on top of keyboard