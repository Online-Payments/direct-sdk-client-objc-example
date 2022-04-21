//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPValidators.h"

@implementation OPValidators

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.validators = [[NSMutableArray alloc] init];
        self.containsSomeTimesRequiredValidator = NO;
    }
    return self;
}

@end
