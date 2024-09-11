//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPEndViewController.h"
#import "OPAppConstants.h"

@implementation OPEndViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] == YES) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:container];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:250];
    [container addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:280];
    [container addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    [self.view addConstraint:constraint];
    
    UILabel *label = [[UILabel alloc] init];
    [container addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedStringFromTable(@"SuccessTitle", kOPAppLocalizable, nil);
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITextView *textView = [[UITextView alloc] init];
    [container addSubview:textView];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.text = NSLocalizedStringFromTable(@"SuccessText", kOPAppLocalizable, nil);
    textView.editable = NO;
    textView.backgroundColor = [UIColor colorWithRed:0.85 green:0.94 blue:0.97 alpha:1];
    textView.textColor = [UIColor colorWithRed:0 green:0.58 blue:0.82 alpha:1];
    textView.layer.cornerRadius = 5.0;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *button = [self.viewFactory buttonWithType:OPButtonTypePrimary];
    [container addSubview:button];
    NSString *continueButtonTitle = NSLocalizedStringFromTable(@"ContinueButtonText", kOPAppLocalizable, nil);
    [button setTitle:continueButtonTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewMapping = NSDictionaryOfVariableBindings(label, textView, button);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[label]-|" options:0 metrics:nil views:viewMapping];
    [container addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[textView]-|" options:0 metrics:nil views:viewMapping];
    [container addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[button]-|" options:0 metrics:nil views:viewMapping];
    [container addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-(20)-[textView(115)]-(20)-[button]" options:0 metrics:nil views:viewMapping];
    [container addConstraints:constraints];
}

- (void)continueButtonTapped {
    [self.target didSelectContinueShopping];
}

@end
