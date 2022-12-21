//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPPaymentProductInputData.h"

@import OnlinePaymentsKit;

@interface OPPaymentProductInputData ()

@property (strong, nonatomic) NSMutableDictionary *fieldValues;
@property (strong, nonatomic) OPStringFormatter *formatter;

@end

@implementation OPPaymentProductInputData

- (NSArray<NSString *> *)fields {
    return self.fieldValues.allKeys;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.formatter = [[OPStringFormatter alloc] init];
        self.fieldValues = [[NSMutableDictionary alloc] init];
        self.errors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (OPPaymentRequest *)paymentRequest {
    OPPaymentRequest *paymentRequest = [[OPPaymentRequest alloc] init];

    if ([self.paymentItem isKindOfClass:[OPPaymentProduct class]]) {
        paymentRequest.paymentProduct = (OPPaymentProduct *) self.paymentItem;
    }
    else {
        paymentRequest.paymentProduct = [[OPPaymentProduct alloc] init];
    }
    paymentRequest.accountOnFile = self.accountOnFile;
    paymentRequest.tokenize = self.tokenize;
    NSDictionary *unmaskedValues = [self unmaskedFieldValues];
    for (NSString *key in unmaskedValues.allKeys) {
        // Check that the value in the field is not the same as in the Account on file.
        // If it is the same, it should not be added to the Payment Request.
        if (self.accountOnFile != nil && [[self.accountOnFile.attributes valueForField:key] isEqualToString:unmaskedValues[key]]) {
            continue;
        }
        NSString *value = unmaskedValues[key];
        [paymentRequest setValue:value forField:key];
    }

    return paymentRequest;
}

- (void)setValue:(NSString *)value forField:(NSString *)paymentProductFieldId {
    [self.fieldValues setObject:value forKey:paymentProductFieldId];
}

- (NSString *)valueForField:(NSString *)paymentProductFieldId {
    NSString *value = [self.fieldValues objectForKey:paymentProductFieldId];
    if (value == nil) {
        value = @"";
    }
    return value;
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId {
    NSInteger cursorPosition = 0;
    return [self maskedValueForField:paymentProductFieldId cursorPosition:&cursorPosition];
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId cursorPosition:(NSInteger *)cursorPosition {
    NSString *value = [self valueForField:paymentProductFieldId];
    NSString *mask = [self maskForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        return [self.formatter formatString:value withMask:mask cursorPosition:cursorPosition];
    }
}

- (NSString *)unmaskedValueForField:(NSString *)paymentProductFieldId {
    NSString *value = [self valueForField:paymentProductFieldId];
    NSString *mask = [self maskForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        NSString *unformattedString = [self.formatter unformatString:value withMask:mask];
        return unformattedString;
    }
}

- (BOOL)fieldIsPartOfAccountOnFile:(NSString *)paymentProductFieldId {
    return [self.accountOnFile hasValueForField:paymentProductFieldId];
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId {
    if ([self fieldIsPartOfAccountOnFile:paymentProductFieldId] == NO) {
        return NO;
    } else {
        return [self.accountOnFile fieldIsReadOnly:paymentProductFieldId];
    }
}

- (void)removeAllFieldValues {
    [self.fieldValues removeAllObjects];
}

- (NSString *)maskForField:(NSString *)paymentProductFieldId {
    OPPaymentProductField *field = [self.paymentItem paymentProductFieldWithId:paymentProductFieldId];
    NSString *mask = field.displayHints.mask;
    return mask;
}

- (NSDictionary *)unmaskedFieldValues {
    NSMutableDictionary *unmaskedFieldValues = [@{} mutableCopy];
    for (OPPaymentProductField *field in self.paymentItem.fields.paymentProductFields) {
        NSString *fieldId = field.identifier;
        if ([self fieldIsReadOnly:fieldId] == NO) {
            NSString *unmaskedValue = [self unmaskedValueForField:fieldId];
            [unmaskedFieldValues setObject:unmaskedValue forKey:fieldId];
        }
    }
    return unmaskedFieldValues;
}

- (void)validateExceptFields:(NSSet *)exceptionFields
{
    [self.errors removeAllObjects];
    OPPaymentRequest *request = self.paymentRequest;
    for (OPPaymentProductField *field in self.paymentItem.fields.paymentProductFields) {
        if (![self fieldIsPartOfAccountOnFile:field.identifier]) {
            if ([[self unmaskedValueForField:field.identifier] isEqualToString:@""]) {
                BOOL hasFixedValidator = NO;
                for (OPValidator *validator in field.dataRestrictions.validators.validators) {
                    if ([validator isKindOfClass:[OPValidatorFixedList class]]) {
                        // It's not possible to choose an empty string with a picker
                        // If it is necessary to choose an invalid value here (placeholder), choose a different value from ""
                        // Except if it is on the accountOnFile
                        hasFixedValidator = true;
                        OPValidatorFixedList *fixedListValidator = (OPValidatorFixedList *) validator;
                        NSString *value = fixedListValidator.allowedValues[0];
                        [self setValue:value forField:field.identifier];
                    }
                }
                // It's not possible to choose an empty string with a date picker
                // If not set, we assume the first is chosen
                // Except if it is on the accountOnFile
                if (!hasFixedValidator && field.type == OPDateString) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMdd";
                    [self setValue: [formatter stringFromDate: [NSDate date]] forField: field.identifier];
                }
                // It's not possible to choose an empty boolean with a switch
                // If not set, we assume false is chosen
                // Except if it is on the accountOnFile
                if (!hasFixedValidator && field.type == OPBooleanString) {
                    [self setValue: @"false" forField: field.identifier];
                }
            }
            
            if ([exceptionFields containsObject:field.identifier]) {
                continue;
            }
            
            NSString *fieldValue = [self unmaskedValueForField:field.identifier];
            [field validateValue:fieldValue forPaymentRequest:request];
            [self.errors addObjectsFromArray:field.errors];
        }
    }
}

- (void)validate
{
    [self validateExceptFields:[NSSet set]];
}

@end
