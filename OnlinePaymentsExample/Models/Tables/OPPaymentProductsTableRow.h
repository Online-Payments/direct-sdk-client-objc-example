//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPFormRow.h"

@interface OPPaymentProductsTableRow : OPFormRow

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSString *accountOnFileIdentifier;
@property (nonatomic) NSString *paymentProductIdentifier;
@property (strong, nonatomic) UIImage *logo;

@end
