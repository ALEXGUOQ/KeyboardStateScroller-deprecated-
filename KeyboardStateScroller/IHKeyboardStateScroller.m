//
//  PRKeyboardStateListener.m
//  Postar
//
//  Created by Frasalie on 29/03/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import "IHKeyboardStateScroller.h"

@implementation IHKeyboardStateScroller

static NSNotificationCenter *_notifications;
static UIView *_focusView;
static UIView *_scrollingView;
static BOOL _isKeyboardVisible;// make public
static int _buffer = 30;// make public
static float _defaultAnimationDuration = 0.3;// make public


+ (void)didChange:(NSNotification *)notification
{
    float animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (animationDuration == 0) {
        animationDuration = _defaultAnimationDuration;
    }
    
    BOOL doShow = NO;
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect windowFrame = [UIApplication sharedApplication].keyWindow.frame;
    
    if (CGRectContainsRect(windowFrame, keyboardFrame) && keyboardFrame.size.height > 0) {
        if (isPortrait) {
            if (keyboardFrame.origin.y == 0 || (keyboardFrame.origin.y + keyboardFrame.size.height == windowFrame.size.height)) {
                doShow = YES;
            }
        } else {
            if (keyboardFrame.origin.x == 0 || (keyboardFrame.origin.x + keyboardFrame.size.width == windowFrame.size.width)) {
                doShow = YES;
            }
        }
    }
    
    
    if (doShow) {
        
        //showing and docked
        if (_focusView && _scrollingView) {
            NSLog(@"y:%f, h:%f", _focusView.frame.origin.y, _focusView.frame.size.height);
            float diff;
            if (isPortrait) {
                diff = keyboardFrame.origin.y - (_focusView.frame.origin.y + _focusView.frame.size.height);
            } else {
                diff = keyboardFrame.origin.x - (_focusView.frame.origin.x + _focusView.frame.size.width);
            }
            
            if (diff < _buffer) {
                [UIView animateWithDuration:animationDuration animations:^{
                    _scrollingView.transform = CGAffineTransformMakeTranslation(0, ( isPortrait ? -keyboardFrame.size.height : -keyboardFrame.size.width));
                }];
            }
        }
        
    }
    else {
        // hiding or splitting
        if (_scrollingView) {
            
            [UIView animateWithDuration:animationDuration
                             animations:^{
                                 _scrollingView.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){}];
        }
    }
    _isKeyboardVisible = doShow;
}

- (id)init
{
    if ((self = [super init])) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

+ (void)registerViewToScroll:(UIView *)focusView scrollingView:(UIView *)scrollingView
{
    if (_notifications == nil) {
        _notifications = [NSNotificationCenter defaultCenter];
        [_notifications addObserver:self selector:@selector(didChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    _focusView = focusView;
    _scrollingView = scrollingView;
}

@end
