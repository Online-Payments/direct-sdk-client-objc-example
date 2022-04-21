//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPAccountsOnFile.h"
#import "OPAccountOnFile.h"
#import "OPPaymentItemDisplayHints.h"
#import "OPPaymentItem.h"
#import "OPBasicPaymentItem.h"
#import "OPPaymentProduct302SpecificData.h"

@interface OPBasicPaymentProduct : NSObject <OPBasicPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) OPPaymentItemDisplayHints *displayHints DEPRECATED_ATTRIBUTE __deprecated_msg("This property wil be removed in the next major update. you can use displayHintsList instead");
@property (strong, nonatomic) NSMutableArray<OPPaymentItemDisplayHints *> *displayHintsList;
@property (strong, nonatomic) OPAccountsOnFile *accountsOnFile;
@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;

@property (nonatomic) NSString *paymentMethod;
@property (nonatomic) NSString *paymentProductGroup;

@property (strong, nonatomic) OPPaymentProduct302SpecificData *paymentProduct302SpecificData;

- (OPAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(OPStringFormatter *)stringFormatter;

@end
