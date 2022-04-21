//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPPaymentItem.h"

@class OPStringFormatter;
@class OPAccountOnFile;
@class OPPaymentProductField;

@interface OPPaymentProductGroup : NSObject <OPPaymentItem>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) OPPaymentItemDisplayHints *displayHints  DEPRECATED_ATTRIBUTE __deprecated_msg("This property wil be removed in the next major update. you can use displayHintsList instead");
@property (nonatomic, strong) NSMutableArray<OPPaymentItemDisplayHints *> *displayHintsList;
@property (strong, nonatomic) OPAccountsOnFile *accountsOnFile;
@property (nonatomic) BOOL allowsTokenization;
@property (nonatomic) BOOL allowsRecurring;
@property (strong, nonatomic) OPPaymentProductFields *fields;

- (OPAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier;
- (void)setStringFormatter:(OPStringFormatter *)stringFormatter;
- (OPPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId;

@end
