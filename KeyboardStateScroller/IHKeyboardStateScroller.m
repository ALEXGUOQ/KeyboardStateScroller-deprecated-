//
//  IHKeyboardStateScroller.m
//  IHKeyboardStateScroller
//
//  Created by Fraser Scott-Morrison on 29/03/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import "IHKeyboardStateScroller.h"

@implementation IHKeyboardStateScroller

static NSNotificationCenter *_notifications;
static UIView *_targetView;
static UIView *_scrollingView;
static BOOL _isKeyboardVisible;
static int _buffer = 30;
static float _defaultAnimationDuration = 0.3; // If keyboard is not animating, animate the scrollingView anyway


+ (void)didChange:(NSNotification *)notification
{
    BOOL doScrollUp = NO;
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    // get the keyboard & window frames
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect windowFrame = [UIApplication sharedApplication].keyWindow.frame;
    
    // if split keyboard is being dragged, then skip notification
    if (keyboardFrame.size.height == 0) {
        CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        
        if (isPortrait) {
            if (keyboardBeginFrame.origin.y + keyboardBeginFrame.size.height == windowFrame.size.height)
                return;
        } else {
            if (keyboardBeginFrame.origin.x + keyboardBeginFrame.size.width == windowFrame.size.width)
                return;
        }
    }
    
    // calculate if we are to scroll up the scrollingView
    if (isPortrait) {
        if (keyboardFrame.origin.y == 0 || (keyboardFrame.origin.y + keyboardFrame.size.height == windowFrame.size.height)) {
            doScrollUp = YES;
        }
    } else {
        if (keyboardFrame.origin.x == 0 || (keyboardFrame.origin.x + keyboardFrame.size.width == windowFrame.size.width)) {
            doScrollUp = YES;
        }
    }
    
    // get animation duration
    float animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (animationDuration == 0) {
        animationDuration = _defaultAnimationDuration;
    }
    
    if (doScrollUp) {
        //showing and docked
        if (_targetView) {
            float diff = 0;
            if (isPortrait) {
                diff = keyboardFrame.origin.y - (_targetView.frame.origin.y + _targetView.frame.size.height);
            } else {
                diff = keyboardFrame.origin.x - (_targetView.frame.origin.x + _targetView.frame.size.width);
            }
            
            if (diff < _buffer) {
                [UIView animateWithDuration:animationDuration animations:^{
                    _scrollingView.transform = CGAffineTransformMakeTranslation(0, ( isPortrait ? -keyboardFrame.size.height : -keyboardFrame.size.width));
                }];
            }
        }
        
    }
    else if (_isKeyboardVisible) {
        // hiding, undocking or splitting
        [UIView animateWithDuration:animationDuration animations:^{
            _scrollingView.transform = CGAffineTransformIdentity;
        }];
    }
    
    _isKeyboardVisible = CGRectContainsRect(windowFrame, keyboardFrame);
}

+ (void)registerViewToScroll:(UIView *)scrollingView with:(UIView *)targetView;
{
    if (_notifications == nil) {
        // make sure we only add this once
        _notifications = [NSNotificationCenter defaultCenter];
        [_notifications addObserver:self selector:@selector(didChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    _targetView = targetView;
    _scrollingView = scrollingView;
}

+ (BOOL)isKeyboardVisible {
    return _isKeyboardVisible;
}

+ (void)setBuffer:(int)buffer {
    _buffer = buffer;
}

@end
