//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPValidatorTermsAndConditions.h"
#import "OPValidatorRegularExpression.h"
#import "OPValidationErrorTermsAndConditions.h"

@implementation OPValidatorTermsAndConditions

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)validate:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    if (![@"true" isEqualToString:value]) {
        [self.errors addObject:[[OPValidationErrorTermsAndConditions alloc]init]];
    }
}

@end
