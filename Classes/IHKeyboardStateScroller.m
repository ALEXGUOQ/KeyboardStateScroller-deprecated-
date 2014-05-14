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
static int _buffer = 0;
static float _defaultAnimationDuration = 0.3; // If keyboard is not animating, animate the scrollingView anyway
static NSLayoutConstraint *_updatedConstraint;
static float _updatedConstraintConstant;
static KeyboardScroll _keyboardScrollType = KeyboardScrollMinimum;
static float _minimumScrollDuration;

+ (void)didChange:(NSNotification *)notification
{
    BOOL isKeyBoardShowing = NO; // isKeyBoardShowing and is it merged and docked.
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
            isKeyBoardShowing = YES;
        }
    } else {
        if (keyboardFrame.origin.x == 0 || (keyboardFrame.origin.x + keyboardFrame.size.width == windowFrame.size.width)) {
            isKeyBoardShowing = YES;
        }
    }
    
    // get animation duration
    float animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (animationDuration == 0) {
        animationDuration = _defaultAnimationDuration;
    }
    
    if (isKeyBoardShowing) {
        
        //showing and docked
        if (_targetView) {
            float diff = 0;
            CGPoint originInWindow = [_targetView.superview convertPoint:_targetView.frame.origin toView:nil];
            switch ([[UIApplication sharedApplication] statusBarOrientation]) {
                case UIInterfaceOrientationPortrait:
                    diff = keyboardFrame.origin.y;
                    diff -= (originInWindow.y + _targetView.frame.size.height);
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    diff = windowFrame.size.height - keyboardFrame.size.height;
                    originInWindow.y = windowFrame.size.height - originInWindow.y;
                    diff -= (originInWindow.y + _targetView.frame.size.height);
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    diff = keyboardFrame.origin.x;
                    diff -= (originInWindow.x + _targetView.frame.size.height);
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    diff = windowFrame.size.width - keyboardFrame.size.width;
                    originInWindow.x = windowFrame.size.width - originInWindow.x;
                    diff -= (originInWindow.x + _targetView.frame.size.height);
                default:
                    break;
            }
            
            
            if (diff < _buffer) {
                
                float displacement = ( isPortrait ? -keyboardFrame.size.height : -keyboardFrame.size.width);
                float delay = 0;
                
                switch (_keyboardScrollType) {
                    case KeyboardScrollMaximum:
                    {
                        _minimumScrollDuration = animationDuration;
                        break;
                    }
                    case KeyboardScrollMinimumDelayed:
                    {
                        float minimumDisplacement = fmaxf(displacement, diff);
                        _minimumScrollDuration = animationDuration * (minimumDisplacement / displacement);
                        displacement = minimumDisplacement;
                        delay = (animationDuration - _minimumScrollDuration);
                        animationDuration = _minimumScrollDuration;
                        break;
                    }
                    case KeyboardScrollMinimum:
                    default:
                    {
                        float minimumDisplacement = fmaxf(displacement, diff);
                        displacement = minimumDisplacement;
                        break;
                    }
                }
                
                [UIView animateWithDuration:animationDuration
                                      delay:delay
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     _scrollingView.transform = CGAffineTransformMakeTranslation(0, displacement);
                                     
                                     for (NSLayoutConstraint *constraint in [_scrollingView.superview constraints]) {
                                         if (constraint.secondAttribute == NSLayoutAttributeCenterY) {
                                             _updatedConstraint = constraint;
                                             _updatedConstraintConstant = constraint.constant;
                                             constraint.constant -= displacement;
                                             break;
                                         }
                                     }
                                 }
                                 completion:nil];
                
            }
        }
        
    }
    else if (_isKeyboardVisible) {
        // hiding, undocking or splitting
        
        switch (_keyboardScrollType) {
            case KeyboardScrollMaximum:
            {
                
                break;
            }
            case KeyboardScrollMinimumDelayed:
            {
                animationDuration = _minimumScrollDuration;
                break;
            }
            case KeyboardScrollMinimum:
            default:
            {
                break;
            }
        }
        
        [UIView animateWithDuration:animationDuration animations:^{
            _scrollingView.transform = CGAffineTransformIdentity;
            
            if (_updatedConstraint) {
                _updatedConstraint.constant = _updatedConstraintConstant;
            }
        }];
        
    }
    
    _isKeyboardVisible = CGRectContainsRect(windowFrame, keyboardFrame);
}

+ (void)registerViewToScroll:(UIView *)scrollingView with:(UIView *)targetView;
{
    if (_notifications == nil) {
        // make sure we only add this once
        _notifications = [NSNotificationCenter defaultCenter];
        //[_notifications addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [_notifications addObserver:self selector:@selector(didChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    _targetView = targetView;
    _scrollingView = scrollingView;
}

+ (void)deregister {
    _targetView = nil;
    _scrollingView = nil;
    _updatedConstraint = nil;
    _updatedConstraintConstant = 0;
}

+ (BOOL)isKeyboardVisible {
    return _isKeyboardVisible;
}

+ (void)setBuffer:(int)buffer {
    _buffer = buffer;
}

+ (void)setMinimumScrollMode:(KeyboardScroll)KeyboardScrollType {
    _keyboardScrollType = KeyboardScrollType;
}

@end