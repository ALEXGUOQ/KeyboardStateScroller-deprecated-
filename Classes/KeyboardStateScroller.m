//
//  KeyboardStateScroller.m
//  KeyboardStateScroller
//
//  Created by Fraser Scott-Morrison on 29/03/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import "KeyboardStateScroller.h"

@implementation KeyboardStateScroller

static NSMutableArray *_targetViews;
static UIView *_scrollingView;
static NSMutableArray *_updatedConstraints;
static NSMutableArray *_updatedConstraintConstants;

static BOOL _isKeyboardVisible;
static BOOL _scrollViewUsesAutoLayout;
static int _buffer = 0;
static int _padding = 0;
static float _defaultAnimationDuration = 0.3; // If keyboard is not animating, animate the scrollingView anyway
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
        for (int i = 0; i < _targetViews.count; i++) {
            UIView *targetView = [_targetViews objectAtIndex:i];
            //showing and docked
            if (targetView) {
                float diff = 0;
                CGPoint originInWindow = [targetView.superview convertPoint:targetView.frame.origin toView:nil];
                switch ([[UIApplication sharedApplication] statusBarOrientation]) {
                    case UIInterfaceOrientationPortrait:
                        diff = keyboardFrame.origin.y;
                        diff -= (originInWindow.y + targetView.frame.size.height);
                        break;
                    case UIInterfaceOrientationPortraitUpsideDown:
                        diff = windowFrame.size.height - keyboardFrame.size.height;
                        originInWindow.y = windowFrame.size.height - originInWindow.y;
                        diff -= (originInWindow.y + targetView.frame.size.height);
                        break;
                    case UIInterfaceOrientationLandscapeLeft:
                        diff = keyboardFrame.origin.x;
                        diff -= (originInWindow.x + targetView.frame.size.height);
                        break;
                    case UIInterfaceOrientationLandscapeRight:
                        diff = windowFrame.size.width - keyboardFrame.size.width;
                        originInWindow.x = windowFrame.size.width - originInWindow.x;
                        diff -= (originInWindow.x + targetView.frame.size.height);
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
                            displacement = minimumDisplacement - _padding;
                            delay = (animationDuration - _minimumScrollDuration);
                            animationDuration = _minimumScrollDuration;
                            break;
                        }
                        case KeyboardScrollMinimum:
                        default:
                        {
                            float minimumDisplacement = fmaxf(displacement, diff);
                            displacement = minimumDisplacement - _padding;
                            break;
                        }
                    }
                    
                    if (_scrollViewUsesAutoLayout) { // if view uses constrains
                        for (NSLayoutConstraint *constraint in _scrollingView.superview.constraints) {
                            if (constraint.secondItem == _scrollingView && (constraint.secondAttribute == NSLayoutAttributeCenterY || constraint.secondAttribute == NSLayoutAttributeTop || constraint.secondAttribute == NSLayoutAttributeBottom)) {
                                [_updatedConstraints addObject:constraint];
                                [_updatedConstraintConstants addObject:[NSNumber numberWithFloat:constraint.constant]];
                                constraint.constant -= displacement;
                                break;
                            }
                        }
                        [_scrollingView.superview setNeedsUpdateConstraints];
                    }

                    [UIView animateWithDuration:animationDuration
                                          delay:delay
                                        options:UIViewAnimationOptionCurveLinear
                                     animations:^{
                                         if (_scrollViewUsesAutoLayout) {
                                             [_scrollingView.superview layoutIfNeeded]; // to animate constraint changes
                                         }
                                         else {
                                             _scrollingView.transform = CGAffineTransformMakeTranslation(0, displacement);
                                         }
                                     }
                                     completion:nil];
                    
                }
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
        
        // restore state
        if (_scrollViewUsesAutoLayout) { // if view uses constrains
            for (int i = 0; i < _updatedConstraints.count; i++) {
                NSLayoutConstraint *updatedConstraint = [_updatedConstraints objectAtIndex:i];
                float updatedConstraintConstant = [[_updatedConstraintConstants objectAtIndex:i] floatValue];
                updatedConstraint.constant = updatedConstraintConstant;
                
            }
            [_scrollingView setNeedsUpdateConstraints]; // to animate constraint changes
        }
        
        [UIView animateWithDuration:animationDuration animations:^{
            if (_scrollViewUsesAutoLayout) {
                [_scrollingView.superview layoutIfNeeded];
            }
            else {
                _scrollingView.transform = CGAffineTransformIdentity;
            }
        } completion:^(BOOL finished){
            [_updatedConstraints removeAllObjects];
            [_updatedConstraintConstants removeAllObjects];
        }];
    }
    
    _isKeyboardVisible = CGRectContainsRect(windowFrame, keyboardFrame);
}

+ (void)setViewToScroll:(UIView *)scrollingView withTarget:(UIView *)targetView;
{
    [self init];
    
    [_targetViews removeAllObjects];
    [_targetViews addObject:targetView];
    _scrollingView = scrollingView;
    _scrollViewUsesAutoLayout = _scrollingView.superview.constraints.count > 0;
}

+ (void)addTarget:(UIView *)targetView;
{
    [_targetViews addObject:targetView];
}

+ (void)removeTarget:(UIView *)targetView;
{
    [_targetViews removeObject:targetView];
}

+ (void)removeAll {
    _targetViews = nil;
    _scrollingView = nil;
}

+ (BOOL)isKeyboardVisible {
    return _isKeyboardVisible;
}

+ (void)setBuffer:(int)buffer {
    _buffer = buffer;
}

+ (void)setScrollPadding:(int)padding {
    _padding = padding;
}

+ (void)setMinimumScrollMode:(KeyboardScroll)KeyboardScrollType {
    _keyboardScrollType = KeyboardScrollType;
}

+ (void)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // make sure we only add this once
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        _targetViews = [[NSMutableArray alloc] init];
        _updatedConstraints = [[NSMutableArray alloc] init];
        _updatedConstraintConstants = [[NSMutableArray alloc] init];
    });
}

@end
