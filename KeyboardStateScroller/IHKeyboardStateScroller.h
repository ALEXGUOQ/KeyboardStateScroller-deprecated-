//
//  IHKeyboardStateScroller.h
//  IHKeyboardStateScroller
//
//  Created by Fraser Scott-Morrison on 29/03/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHKeyboardStateScroller : NSObject

+ (void)registerViewToScroll:(UIView *)focusView scrollingView:(UIView *)scrollingView;

@end
