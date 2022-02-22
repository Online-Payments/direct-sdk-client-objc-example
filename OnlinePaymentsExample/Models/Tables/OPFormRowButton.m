//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPFormRowButton.h"

@implementation OPFormRowButton

- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title target: (nonnull id)target action: (nonnull SEL)action {
    self = [super init];
    
    if (self) {
        self.buttonType = OPButtonTypePrimary;
        self.title = title;
        self.target = target;
        self.action = action;
    }
    
    return self;
}


@end
