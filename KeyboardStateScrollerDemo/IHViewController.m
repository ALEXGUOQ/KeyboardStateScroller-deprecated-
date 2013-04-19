//
//  IHViewController.m
//  IHKeyboardStateScroller
//
//  Created by Fraser Scott-Morrison on 18/04/13.
//  Copyright (c) 2013 Idle Hands Apps. All rights reserved.
//

#import "IHViewController.h"
#import "IHKeyboardStateScroller.h"

@interface IHViewController ()

@end

@implementation IHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.scrollingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"diamond_upholstery"]];
    
    [IHKeyboardStateScroller registerViewToScroll:self.focusView scrollingView:self.scrollingView];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; 
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end