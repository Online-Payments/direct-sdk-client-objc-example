//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPIINDetail.h"

@implementation OPIINDetail

- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId allowedInContext:(BOOL)allowedInContext {
    self = [super init];
    if (self) {
        _paymentProductId = paymentProductId;
        _allowedInContext = allowedInContext;
    }

    return self;
}

@end
