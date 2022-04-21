//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "OPBasicPaymentProduct.h"

@interface OPBasicPaymentProducts : NSObject

@property (strong, nonatomic) NSMutableArray *paymentProducts;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (OPBasicPaymentProduct *)paymentProductWithIdentifier:(NSString *)paymentProductIdentifier;
- (void)sort;
- (void)setStringFormatter:(OPStringFormatter *)stringFormatter;

@end
