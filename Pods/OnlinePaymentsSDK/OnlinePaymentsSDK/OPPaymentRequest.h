//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "OPPaymentProduct.h"
#import "OPPaymentRequest.h"

@interface OPPaymentRequest : NSObject

@property (strong, nonatomic) OPPaymentProduct *paymentProduct;
@property (strong, nonatomic) OPAccountOnFile *accountOnFile;
@property (strong, nonatomic) NSMutableArray *errors;
@property (nonatomic) BOOL tokenize;

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId;
- (void)validate;
- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId;
- (NSDictionary *)unmaskedFieldValues;

@end
