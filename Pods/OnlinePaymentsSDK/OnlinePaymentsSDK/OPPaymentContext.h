//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "OPPaymentAmountOfMoney.h"

@interface OPPaymentContext : NSObject

@property (strong, nonatomic) OPPaymentAmountOfMoney *amountOfMoney;
@property (nonatomic, readonly) BOOL isRecurring;
@property (strong, nonatomic, readonly) NSString *countryCode;
@property (strong, nonatomic) NSString *locale;
@property (assign, nonatomic) BOOL forceBasicFlow;

- (instancetype)initWithAmountOfMoney:(OPPaymentAmountOfMoney *)amountOfMoney isRecurring:(BOOL)isRecurring countryCode:(NSString *)countryCode;

@end
