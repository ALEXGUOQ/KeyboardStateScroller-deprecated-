//
//  PRKeyboardStateListener.h
//  Postar
//
//  Created by Frasalie on 29/03/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHKeyboardStateScroller : NSObject

///@property (nonatomic) BOOL isKeyboardVisible;
//@property (nonatomic, strong) UIView *responderView;
//@property (nonatomic, strong) UIView *parentView;

//+ (void)responderView:(UIView *)responderView;
//+ (void)parentView:(UIView *)parentView;
+ (void)registerViewToScroll:(UIView *)focusView scrollingView:(UIView *)scrollingView;

@end
