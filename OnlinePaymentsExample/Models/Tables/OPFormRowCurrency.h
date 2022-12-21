//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPFormRowField.h"
#import "OPFormRowWithInfoButton.h"
#import "OPIntegerTextField.h"
#import "OPFractionalTextField.h"
@import OnlinePaymentsKit;

@interface OPFormRowCurrency : OPFormRowWithInfoButton

@property (strong, nonatomic) OPFormRowField *integerField;
@property (strong, nonatomic) OPFormRowField *fractionalField;
@property (strong, nonatomic) OPPaymentProductField *paymentProductField;

- (instancetype)initWithPaymentProductField:(OPPaymentProductField *)paymentProductField andIntegerField:(OPFormRowField *)integerField andFractionalField:(OPFormRowField *)fractionalField;

@end
