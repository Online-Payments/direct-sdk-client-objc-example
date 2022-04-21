//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPValidatorLength.h"
#import "OPValidationErrorLength.h"

@implementation OPValidatorLength

- (void)validate:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    OPValidationErrorLength *error = [[OPValidationErrorLength alloc] init];
    error.minLength = self.minLength;
    error.maxLength = self.maxLength;
    if (value.length < self.minLength) {
        [self.errors addObject:error];
    }
    if (value.length > self.maxLength) {
        [self.errors addObject:error];
    }
}

@end
