//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPViewFactory.h"
#import "OPFormRowErrorMessage.h"

#import <OnlinePaymentsSDK/OPPaymentRequest.h>
#import <OnlinePaymentsSDK/OPValidationError.h>

@class OPIINDetailsResponse;
@class OPPaymentProductInputData;

@interface OPFormRowsConverter : NSObject

+ (NSString *)errorMessageForError:(OPValidationError *)error withCurrency:(BOOL)forCurrency;

- (NSMutableArray *)formRowsFromInputData:(OPPaymentProductInputData *)inputData viewFactory:(OPViewFactory *)viewFactory confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts;

@end
