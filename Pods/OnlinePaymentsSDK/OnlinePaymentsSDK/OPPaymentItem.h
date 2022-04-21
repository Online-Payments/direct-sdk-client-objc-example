//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPBasicPaymentItem.h"

@class OPPaymentItemDisplayHints;
@class OPAccountsOnFile;
@class OPPaymentProductFields;
@class OPPaymentProductField;

@protocol OPPaymentItem <NSObject, OPBasicPaymentItem>

@property (strong, nonatomic) OPPaymentProductFields *fields;

- (OPPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
