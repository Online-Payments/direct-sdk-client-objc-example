//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "OPIINStatus.h"

@interface OPIINDetailsResponse : NSObject

@property (strong, nonatomic, readonly) NSString* paymentProductId;
@property (nonatomic, readonly) OPIINStatus status;

@property (strong, nonatomic, readonly) NSArray *coBrands;
@property (strong, nonatomic, readonly) NSString *countryCode;
@property (assign, nonatomic, readonly, getter=isAllowedInContext) BOOL allowedInContext;

- (instancetype)initWithStatus:(OPIINStatus)status;
- (instancetype)initWithPaymentProductId:(NSString *)paymentProductId status:(OPIINStatus)status coBrands:(NSArray *)coBrands countryCode:(NSString *)countryCode allowedInContext:(BOOL)allowedInContext;

@end
