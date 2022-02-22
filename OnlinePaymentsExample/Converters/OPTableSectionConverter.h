//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPPaymentProductsTableSection.h"
#import <OnlinePaymentsSDK/OPBasicPaymentProducts.h>
#import <OnlinePaymentsSDK/OPPaymentItems.h>

@interface OPTableSectionConverter : NSObject

+ (OPPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentItems:(OPPaymentItems *)paymentItems;
+ (OPPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentItems:(OPPaymentItems *)paymentItems;

@end
