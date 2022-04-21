//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPValidatorRange.h"
#import "OPValidationErrorRange.h"

@interface OPValidatorRange ()

@property (strong, nonatomic) NSNumberFormatter *formatter;

@end

@implementation OPValidatorRange

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.formatter = [[NSNumberFormatter alloc] init];
        self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)validate:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    NSNumber *number = [self.formatter numberFromString:value];
    NSInteger valueAsInteger = [number integerValue];
    OPValidationErrorRange *error = [[OPValidationErrorRange alloc] init];
    error.minValue = self.minValue;
    error.maxValue = self.maxValue;
    if (number == nil) {
        [self.errors addObject:error];
    } else if (valueAsInteger < self.minValue) {
        [self.errors addObject:error];
    } else if (valueAsInteger > self.maxValue) {
        [self.errors addObject:error];
    }
}

@end
