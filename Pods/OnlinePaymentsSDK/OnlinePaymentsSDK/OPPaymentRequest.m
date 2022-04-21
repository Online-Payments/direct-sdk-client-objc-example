//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPPaymentRequest.h"
#import  "OPAccountOnFileAttribute.h"
#import  "OPValidatorFixedList.h"

@interface OPPaymentRequest ()

@property (strong, nonatomic) NSMutableDictionary *fieldValues;
@property (strong, nonatomic) OPStringFormatter *formatter;

@end

@implementation OPPaymentRequest

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.formatter = [[OPStringFormatter alloc] init];
        self.fieldValues = [[NSMutableDictionary alloc] init];
        self.errors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId
{
    [self.fieldValues setObject:value forKey:paymentProductFieldId];
}

- (NSString *)valueForField:(NSString *)paymentProductFieldId
{
    NSString *value = [self.fieldValues objectForKey:paymentProductFieldId];
    if (value == nil) {
        value = @"";
        OPPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:paymentProductFieldId];
        for (OPValidator *validator in field.dataRestrictions.validators.validators) {
            if ([validator class] == [OPValidatorFixedList class]) {
                OPValidatorFixedList *fixedListValidator = (OPValidatorFixedList *)validator;
                value = fixedListValidator.allowedValues[0];
                [self setValue:value forField:paymentProductFieldId];
            }
        }
    }
    return value;
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId
{
    NSInteger cursorPosition = 0;
    return [self maskedValueForField:paymentProductFieldId cursorPosition:&cursorPosition];
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition
{
    NSString *value = [self valueForField:paymentProductFieldId];
    NSString *mask = [self maskForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        return [self.formatter formatString:value withMask:mask cursorPosition:cursorPosition];
    }
}

- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId
{
    NSString *value = [self valueForField:paymentProductFieldId];
    NSString *mask = [self maskForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        NSString *unformattedString = [self.formatter unformatString:value withMask:mask];
        return unformattedString;
    }
}

- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId
{
    return [self.accountOnFile hasValueForField:paymentProductFieldId];
}

- (BOOL)fieldIsPartOfAccountOnFileAndHasNotChanged:(NSString *)paymentProductFieldId
{
    if ([self fieldIsPartOfAccountOnFile:paymentProductFieldId]
        && ([self fieldIsReadOnly:paymentProductFieldId]
            // Values that are not altered, should not be added to the Payment Request. nil values are therefore considered un-altered.
            || [self unmaskedValueForField:paymentProductFieldId].length == 0)) {
        return YES;
    }
    return NO;
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId
{
    if ([self fieldIsPartOfAccountOnFile:paymentProductFieldId] == NO) {
        return NO;
    } else {
        return [self.accountOnFile fieldIsReadOnly:paymentProductFieldId];
    }
}

- (NSString *)maskForField:(NSString *)paymentProductFieldId
{
    OPPaymentProductField *field = [self.paymentProduct paymentProductFieldWithId:paymentProductFieldId];
    NSString *mask = field.displayHints.mask;
    return mask;
}

- (void)validate
{
    if (self.paymentProduct == nil || ![self.paymentProduct isKindOfClass:[OPPaymentProduct class]]) {
        [NSException raise:@"Invalid payment product" format:@"Payment product is invalid"];
    }
    
    [self.errors removeAllObjects];
    for (OPPaymentProductField *field in self.paymentProduct.fields.paymentProductFields) {
        if ([self fieldIsPartOfAccountOnFileAndHasNotChanged:field.identifier] == NO) {
            NSString *fieldValue = [self unmaskedValueForField:field.identifier];
            [field validateValue:fieldValue forPaymentRequest:self];
            [self.errors addObjectsFromArray:field.errors];
        }
    }
}

- (NSDictionary *)unmaskedFieldValues
{
    NSMutableDictionary *unmaskedFieldValues = [@{} mutableCopy];
    for (OPPaymentProductField *field in self.paymentProduct.fields.paymentProductFields) {
        NSString *fieldId = field.identifier;
        if ([self fieldIsReadOnly:fieldId] == NO) {
            NSString *unmaskedValue = [self unmaskedValueForField:fieldId];
            [unmaskedFieldValues setObject:unmaskedValue forKey:fieldId];
        }
    }
    return unmaskedFieldValues;
}

@end
