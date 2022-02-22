//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPFormRowField.h"
#import "OPFormRowWithInfoButton.h"
#import "OPTextField.h"
#import <OnlinePaymentsSDK/OPPaymentProductField.h>

@interface OPFormRowTextField : OPFormRowWithInfoButton

@property (strong, nonatomic) OPPaymentProductField * _Nonnull paymentProductField;
@property (strong, nonatomic) UIImage * _Nullable logo;
@property (strong, nonatomic) OPFormRowField * _Nonnull field;

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull OPPaymentProductField *)paymentProductField field: (nonnull OPFormRowField*)field;

@end
