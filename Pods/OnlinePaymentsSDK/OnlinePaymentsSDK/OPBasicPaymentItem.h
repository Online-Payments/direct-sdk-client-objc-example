//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

@class OPAccountsOnFile;
@class OPPaymentItemDisplayHints;

@protocol OPBasicPaymentItem <NSObject>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) OPPaymentItemDisplayHints *displayHints DEPRECATED_ATTRIBUTE __deprecated_msg("This property wil be removed in the next major update. you can use displayHintsList instead");
@property (nonatomic, strong) NSMutableArray<OPPaymentItemDisplayHints *> *displayHintsList;
@property (strong, nonatomic) OPAccountsOnFile *accountsOnFile;

@end
