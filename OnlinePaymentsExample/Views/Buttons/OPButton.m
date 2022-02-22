//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPButton.h"
#import "OPAppConstants.h"

@implementation OPButton

- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.type = OPButtonTypePrimary;
        self.layer.cornerRadius = 5;
    }
    
    return self;
}


- (void)setType:(OPButtonType)type {
    _type = type;
    switch (type) {
        case OPButtonTypePrimary:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = kOPPrimaryColor;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;
        case OPButtonTypeSecondary:
            [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor grayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = [UIColor clearColor];
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;
        case OPButtonTypeDestructive:
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            self.backgroundColor = kOPDestructiveColor;
            self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
            break;

    }
}

- (void)setEnabled:(BOOL)enabled {
    super.enabled = enabled;
    self.alpha = enabled ? 1 : 0.3;
}

@end
