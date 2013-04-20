//
//  IHKeyboardStateScroller.h
//  IHKeyboardStateScroller
//
//  Created by Fraser Scott-Morrison on 29/03/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHKeyboardStateScroller : NSObject

+ (void)registerViewToScroll:(UIView *)scrollingView with:(UIView *)targetView;

// utility method to find out if the keyboard is visible.  Works for docked, undocked and split keyboards
+ (BOOL)isKeyboardVisible;

// If the visible keyboard plus the buffer intersect with the targetView, then the scrollingView will be scrolled.  Default buffer is 30 points
+ (void)setBuffer:(int)buffer;

@end
