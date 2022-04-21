//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

@class OPPaymentRequest;

@interface OPValidator : NSObject

@property (strong, nonatomic) NSMutableArray *errors;

- (void)validate:(NSString *)value DEPRECATED_ATTRIBUTE;
- (void)validate:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request;

@end
