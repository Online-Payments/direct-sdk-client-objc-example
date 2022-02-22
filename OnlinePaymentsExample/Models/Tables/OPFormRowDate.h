//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPFormRow.h"
#import <OnlinePaymentsSDK/OPPaymentProductField.h>

@interface OPFormRowDate : OPFormRow

@property (strong, nonatomic) OPPaymentProductField * _Nonnull paymentProductField;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSDate *date;

@end
