//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPIINDetailsResponse.h"

@implementation OPIINDetailsResponse

- (instancetype)initWithStatus:(OPIINStatus)status {
    self = [super init];
    if (self) {
        _status = status;
    }

    return self;
}

- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId status:(OPIINStatus)status coBrands:(NSArray *)coBrands countryCode:(NSString *)countryCode allowedInContext:(BOOL)allowedInContext {
    self = [super init];
    if (self) {
        _paymentProductId = paymentProductId;
        _status = status;
        _coBrands = coBrands;
        _countryCode = countryCode;
        _allowedInContext = allowedInContext;
    }

    return self;
}

@end
