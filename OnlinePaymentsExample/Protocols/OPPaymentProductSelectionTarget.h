//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef OPPaymentProductSelectionTarget_h
#define OPPaymentProductSelectionTarget_h

#import "OPPaymentType.h"

#import <OnlinePaymentsSDK/OPBasicPaymentProduct.h>
#import <OnlinePaymentsSDK/OPAccountOnFile.h>

@protocol OPPaymentItem;

@protocol OPPaymentProductSelectionTarget <NSObject>

- (void)didSelectPaymentItem:(NSObject <OPBasicPaymentItem> *)paymentItem accountOnFile:(OPAccountOnFile *)accountOnFile;

@end

#endif /* OPPaymentProductSelectionTarget_h */
