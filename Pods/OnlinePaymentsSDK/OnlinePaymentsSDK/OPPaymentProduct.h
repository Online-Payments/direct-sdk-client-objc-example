//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPBasicPaymentProduct.h"
#import "OPPaymentProductFields.h"
#import "OPPaymentProductField.h"

@interface OPPaymentProduct : OPBasicPaymentProduct <OPPaymentItem>

@property (strong, nonatomic) OPPaymentProductFields *fields;

- (OPPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
