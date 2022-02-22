//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef OPPaymentRequestTarget_h
#define OPPaymentRequestTarget_h

#import <OnlinePaymentsSDK/OPPaymentRequest.h>

@protocol OPPaymentRequestTarget <NSObject>

- (void)didSubmitPaymentRequest:(OPPaymentRequest *)paymentRequest;
- (void)didCancelPaymentRequest;

@end

#endif /* OPPaymentRequestTarget_h */
