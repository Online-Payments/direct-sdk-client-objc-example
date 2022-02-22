//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPFormRowCurrency.h"

@implementation OPFormRowCurrency

- (instancetype)initWithPaymentProductField:(OPPaymentProductField *)paymentProductField andIntegerField:(OPFormRowField *)integerField andFractionalField:(OPFormRowField *)fractionalField
{
    self = [super init];
    if (self) {
        self.paymentProductField = paymentProductField;
        self.integerField = integerField;
        self.fractionalField = fractionalField;
    }
    return self;
}

@end
