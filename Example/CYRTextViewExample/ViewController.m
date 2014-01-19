//
//  ViewController.m
//  CYRTextViewExample
//
//  Created by Illya Busigin on 1/5/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

#import "ViewController.h"

#import "QEDTextView.h"

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, strong) QEDTextView *textView;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"CYRTextView";
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    QEDTextView *textView = [[QEDTextView alloc] initWithFrame:self.view.bounds];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    textView.delegate = self;
    
    self.textView = textView;
    
    [self.view addSubview:textView];
    
    self.textView.text = @"// Test comment\n\n"\
    @"// Let's solve our first equation\n"\
    @"x = 1 / (1 + x) // equation to solve for x\n"\
    @"x > 0 // restrict to positive root\n\n"\
    @"// Let's create a user function\n"\
    @"// The standard function random returns a random value between 0 an 1\n"\
    @"g(x) := 0.005 * (x + 1) * (x - 1) + 0.1 * (random - 0.5)\n\n"\
    @"// Now let's plot the two functions together on one chart\n"\
    @"plot f(x), g(x)";
}


#pragma mark - Notification Handlers

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
    
    [self.navigationItem setRightBarButtonItem:dismissButton animated:YES];
    
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    self.navigationItem.rightBarButtonItem = nil;
    [self moveTextViewForKeyboard:aNotification up:NO];
}


#pragma mark - Convenience

- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up
{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = _textView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    newFrame.size.height -= keyboardFrame.size.height * (up?1:-1);
    _textView.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)dismissKeyboard
{
    [_textView resignFirstResponder];
}

@end
