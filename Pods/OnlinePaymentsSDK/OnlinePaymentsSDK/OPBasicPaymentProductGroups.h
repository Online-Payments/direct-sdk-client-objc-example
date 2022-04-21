//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPStringFormatter;
@class OPBasicPaymentProductGroup;

@interface OPBasicPaymentProductGroups : NSObject

@property (nonatomic, strong) NSMutableArray *paymentProductGroups;

- (BOOL)hasAccountsOnFile;
- (NSArray *)accountsOnFile;
- (OPBasicPaymentProductGroup *)paymentProductGroupWithIdentifier:(NSString *)paymentProductGroupIdentifier;
- (void)sort;
- (void)setStringFormatter:(OPStringFormatter *)stringFormatter;

@end
