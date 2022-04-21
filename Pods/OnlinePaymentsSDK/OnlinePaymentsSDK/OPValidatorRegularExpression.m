//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPValidatorRegularExpression.h"
#import "OPValidationErrorRegularExpression.h"

@implementation OPValidatorRegularExpression

- (instancetype)initWithRegularExpression:(NSRegularExpression *)regularExpression
{
    self = [super init];
    if (self != nil) {
        _regularExpression = regularExpression;
    }
    return self;
}

- (void)validate:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    NSInteger numberOfMatches = [self.regularExpression numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)];
    if (numberOfMatches != 1) {
        OPValidationErrorRegularExpression *error = [[OPValidationErrorRegularExpression alloc] init];
        [self.errors addObject:error];
    }
}

@end
