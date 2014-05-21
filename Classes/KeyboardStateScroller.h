//
//  KeyboardStateScroller.h
//  KeyboardStateScroller
//
//  Created by Fraser Scott-Morrison on 29/03/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

enum KeyboardScroll {
    KeyboardScrollMaximum = 0,
    KeyboardScrollMinimum = 1,
    KeyboardScrollMinimumDelayed = 2
}
typedef KeyboardScroll;

@interface KeyboardStateScroller : NSObject

+ (void)setMinimumScrollMode:(KeyboardScroll)KeyboardScrollType;

+ (void)setViewToScroll:(UIView *)scrollingView withTarget:(UIView *)targetView;
+ (void)addTarget:(UIView *)targetView;
+ (void)removeTarget:(UIView *)targetView;
+ (void)removeAll;

// utility method to find out if the keyboard is visible. Works for docked, undocked and split keyboards
+ (BOOL)isKeyboardVisible;

// If the visible keyboard plus the buffer intersect with the targetView, then the scrollingView will be scrolled. Default buffer is 0 points
+ (void)setBuffer:(int)buffer;

// padding to put between the keyboard and scrolling view. Default padding is 0 points
+ (void)setScrollPadding:(int)padding;

@end
