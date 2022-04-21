//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPPaymentAmountOfMoney.h"
#import "OPSDKConstants.h"

@implementation OPPaymentAmountOfMoney

- (instancetype)initWithTotalAmount:(long)totalAmount currencyCode:(NSString *)currencyCode {
    if ([kOPCurrencyCodes rangeOfString:currencyCode].location == NSNotFound) {
        [NSException raise:@"Invalid currency code" format:@"Currency code %@ is invalid", currencyCode];
    }

    self = [super init];
    if (self) {
        _totalAmount = totalAmount;
        _currencyCode = currencyCode;
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld-%@", (long) self.totalAmount, self.currencyCode];
}

@end
