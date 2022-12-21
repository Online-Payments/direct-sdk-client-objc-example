//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPFormRow.h"
@import OnlinePaymentsKit;

@interface OPFormRowTooltip : OPFormRow

@property (strong, nonatomic) OPPaymentProductField *paymentProductField;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;

@end
