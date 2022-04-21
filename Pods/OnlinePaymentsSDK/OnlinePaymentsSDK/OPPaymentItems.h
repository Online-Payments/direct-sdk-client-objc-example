//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPStringFormatter;
@protocol OPBasicPaymentItem;
@class OPBasicPaymentProducts;
@class OPBasicPaymentProductGroups;

@interface OPPaymentItems : NSObject

@property (nonatomic, strong) NSMutableArray *paymentItems;

- (instancetype)initWithPaymentProducts:(OPBasicPaymentProducts *)products groups:(OPBasicPaymentProductGroups *)groups;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (NSObject<OPBasicPaymentItem> *)paymentItemWithIdentifier:(NSString *)paymentItemIdentifier;
- (void)sort;

@end
