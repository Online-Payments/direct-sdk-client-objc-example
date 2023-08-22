//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

@protocol OPPaymentItem;
@class OPAccountOnFile;
@class OPPaymentRequest;

@interface OPPaymentProductInputData : NSObject

@property (strong, nonatomic) NSObject<OPPaymentItem> *paymentItem;
@property (strong, nonatomic) OPAccountOnFile *accountOnFile;
@property (strong, nonatomic) OPPaymentRequest *paymentRequest;
@property (nonatomic) BOOL tokenize;
@property (nonatomic, readonly, strong) NSArray *fields;
@property (strong, nonatomic) NSMutableArray *errors;

- (void)createPaymentRequest;

- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId;

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId;

- (void)validate;
- (void)validateExceptFields:(NSSet *)exceptionFields;
- (void)removeAllFieldValues;

@end
