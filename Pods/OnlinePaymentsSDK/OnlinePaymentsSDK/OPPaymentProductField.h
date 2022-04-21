//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPPaymentProductFieldDisplayHints.h"
#import "OPDataRestrictions.h"
#import "OPType.h"

@class OPPaymentRequest;

@interface OPPaymentProductField : NSObject

@property (strong, nonatomic) OPDataRestrictions *dataRestrictions;
@property (strong, nonatomic) OPPaymentProductFieldDisplayHints *displayHints;
@property (strong, nonatomic) NSString *identifier;
@property (assign, nonatomic) BOOL usedForLookup;
@property (nonatomic) OPType type;
@property (strong, nonatomic) NSMutableArray *errors;

- (void)validateValue:(NSString *)value DEPRECATED_ATTRIBUTE;
- (void)validateValue:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request;

@end
