//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import  "OPPaymentItemConverter.h"
#import  "OPPaymentItem.h"
#import  "OPPaymentProductFields.h"
#import  "OPPaymentProductField.h"
#import  "OPMacros.h"
#import  "OPValueMappingItem.h"
#import  "OPValidator.h"
#import  "OPValidatorLuhn.h"
#import  "OPValidatorExpirationDate.h"
#import  "OPValidatorEmailAddress.h"
#import  "OPValidatorRegularExpression.h"
#import  "OPValidatorRange.h"
#import  "OPValidatorLength.h"
#import  "OPValidatorFixedList.h"
#import  "OPDisplayElementsConverter.h"
#import  "OPDisplayElement.h"
#import  "OPValidatorTermsAndConditions.h"
#import  "OPValidatorIBAN.h"

@implementation OPPaymentItemConverter 

- (void)setPaymentItem:(NSObject <OPPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem {
    [self setBasicPaymentItem:paymentItem JSON:rawPaymentItem];
    [self setPaymentProductFields:paymentItem.fields JSON:rawPaymentItem[@"fields"]];
}

//Product Fields converter
- (void)setPaymentProductFields:(OPPaymentProductFields *)fields JSON:(NSArray *)rawFields
{
    for (NSDictionary *rawField in rawFields) {
        OPPaymentProductField *field = [self paymentProductFieldFromJSON:rawField];
        [fields.paymentProductFields addObject:field];
    }
    [fields sort];
}

- (OPPaymentProductField *)paymentProductFieldFromJSON:(NSDictionary *)rawField
{
    OPPaymentProductField *field = [[OPPaymentProductField alloc] init];
    [self setDataRestrictions:field.dataRestrictions JSON:[rawField objectForKey:@"dataRestrictions"]];
    field.identifier = [rawField objectForKey:@"id"];
    field.usedForLookup = ((NSNumber *)[rawField objectForKey:@"usedForLookup"]).boolValue;
    [self setDisplayHints:field.displayHints JSON:[rawField objectForKey:@"displayHints"]];
    [self setType:field rawField:rawField];

    return field;
}

- (void)setType:(OPPaymentProductField *)field rawField:(NSDictionary *)rawField
{
    NSString *rawType = [rawField objectForKey:@"type"];
    if ([rawType isEqualToString:@"string"]) {
        field.type = OPString;
    } else if ([rawType isEqualToString:@"integer"]) {
        field.type = OPInteger;
    } else if ([rawType isEqualToString:@"expirydate"]) {
        field.type = OPExpirationDate;
    } else if ([rawType isEqualToString:@"numericstring"]) {
        field.type = OPNumericString;
    } else if ([rawType isEqualToString:@"boolean"]){
        field.type = OPBooleanString;
    } else if ([rawType isEqualToString:@"date"]){
        field.type = OPDateString;
    } else {
        DLog(@"Type %@ in JSON fragment %@ is invalid", rawType, rawField);
    }
}

- (void)setDisplayHints:(OPPaymentProductFieldDisplayHints *)hints JSON:(NSDictionary *)rawHints
{
    hints.alwaysShow = [[rawHints objectForKey:@"alwaysShow"] boolValue];
    hints.displayOrder = [[rawHints objectForKey:@"displayOrder"] integerValue];
    [self setFormElement:hints.formElement JSON:[rawHints objectForKey:@"formElement"]];
    hints.mask = [rawHints objectForKey:@"mask"];
    hints.obfuscate = [[rawHints objectForKey:@"obfuscate"] boolValue];
    hints.label = [rawHints objectForKey:@"label"];
    hints.link = [NSURL URLWithString:[rawHints objectForKey:@"link"]];
    [self setPreferredInputType:hints JSON:[rawHints objectForKey:@"preferredInputType"]];
    [self setTooltip:hints.tooltip JSON:[rawHints objectForKey:@"tooltip"]];
}

- (void)setPreferredInputType:(OPPaymentProductFieldDisplayHints *)hints JSON:(NSString *)rawPreferredInputType
{
    if ([rawPreferredInputType isEqualToString:@"StringKeyboard"] == YES) {
        hints.preferredInputType = OPStringKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"IntegerKeyboard"] == YES) {
        hints.preferredInputType = OPIntegerKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"EmailAddressKeyboard"]) {
        hints.preferredInputType = OPEmailAddressKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"PhoneNumberKeyboard"]) {
        hints.preferredInputType = OPPhoneNumberKeyboard;
    } else if ([rawPreferredInputType isEqualToString:@"DateKeyboard"]) {
        hints.preferredInputType = OPDateKeyboard;
    } else if (rawPreferredInputType == nil) {
        hints.preferredInputType = OPNoKeyboard;
    } else {
        DLog(@"Preferred input type %@ is invalid", rawPreferredInputType);
    }
}

- (void)setTooltip:(OPTooltip *)tooltip JSON:(NSDictionary *)rawTooltip
{
    tooltip.imagePath = [rawTooltip objectForKey:@"image"];
}

- (void)setFormElement:(OPFormElement *)formElement JSON:(NSDictionary *)rawFormElement
{
    [self setFormElementType:formElement JSON:rawFormElement];
}

- (void)setFormElementType:(OPFormElement *)formElement JSON:(NSDictionary *)rawFormElement
{
    NSString *rawType = [rawFormElement objectForKey:@"type"];
    if ([rawType isEqualToString:@"text"] == YES) {
        formElement.type = OPTextType;
    } else if ([rawType isEqualToString:@"currency"] == YES) {
        formElement.type = OPCurrencyType;
    } else if ([rawType isEqualToString:@"list"] == YES) {
        formElement.type = OPListType;
        [self setValueMapping:formElement JSON:[rawFormElement objectForKey:@"valueMapping"]];
    } else if ([rawType isEqualToString:@"date"] == YES) {
        formElement.type = OPDateType;
    } else if ([rawType isEqualToString:@"boolean"] == YES) {
        formElement.type = OPBoolType;
    } else {
        DLog(@"Form element %@ is invalid", rawFormElement);
    }
}

- (void)setValueMapping:(OPFormElement *)formElement JSON:(NSArray *)rawValueMapping
{
    for (NSDictionary *rawValueMappingItem in rawValueMapping) {
        OPValueMappingItem *item = [[OPValueMappingItem alloc] init];
        NSArray *displayElements = [rawValueMappingItem objectForKey:@"displayElements"];
        BOOL foundDisplayElement = NO;
        if (displayElements != nil) {
            OPDisplayElementsConverter *converter = [[OPDisplayElementsConverter alloc]init];
            item.displayElements = [converter displayElementsFromJSON:displayElements];
            for (OPDisplayElement *el in [item displayElements]) {
                if ([el.identifier isEqualToString:@"displayName"]) {
                    item.displayName = el.value;
                    foundDisplayElement = YES;
                }
            }
            if (!foundDisplayElement && item.displayName != nil) {
                OPDisplayElement *el = [[OPDisplayElement alloc]init];
                el.identifier = @"displayName";
                el.value = item.displayName;
                el.type = OPDisplayElementTypeString;
                [item setDisplayElements:[item.displayElements arrayByAddingObject:el]];
            }
        }
        else {
            item.displayName = [rawValueMappingItem objectForKey:@"displayName"];
            OPDisplayElement *el = [[OPDisplayElement alloc]init];
            el.identifier = @"displayName";
            el.value = item.displayName;
            el.type = OPDisplayElementTypeString;
            item.displayElements = [NSArray arrayWithObject:el];
        }
        item.displayName = [rawValueMappingItem objectForKey:@"displayName"];
        item.value = [rawValueMappingItem objectForKey:@"value"];
        [formElement.valueMapping addObject:item];
    }
}

- (void)setDataRestrictions:(OPDataRestrictions *)restrictions JSON:(NSDictionary *)rawRestrictions
{
    restrictions.isRequired = [[rawRestrictions objectForKey:@"isRequired"] boolValue];
    [self setValidators:restrictions.validators JSON:[rawRestrictions objectForKey:@"validators"]];
}

- (void)setValidators:(OPValidators *)validators JSON:(NSDictionary *)rawValidators
{
    OPValidator *validator;
    if ([rawValidators objectForKey:@"luhn"] != nil) {
        validator = [[OPValidatorLuhn alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"expirationDate"] != nil) {
        validator = [[OPValidatorExpirationDate alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"range"] != nil) {
        validator = [self validatorRangeFromJSON:[rawValidators objectForKey:@"range"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"length"] != nil) {
        validator = [self validatorLengthFromJSON:[rawValidators objectForKey:@"length"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"fixedList"] != nil) {
        validator = [self validatorFixedListFromJSON:[rawValidators objectForKey:@"fixedList"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"emailAddress"] != nil) {
        validator = [[OPValidatorEmailAddress alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"regularExpression"] != nil) {
        validator = [self validatorRegularExpressionFromJSON:[rawValidators objectForKey:@"regularExpression"]];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"termsAndConditions"] != nil) {
        validator = [[OPValidatorTermsAndConditions alloc] init];
        [validators.validators addObject:validator];
    }
    if ([rawValidators objectForKey:@"iban"] != nil) {
        validator = [[OPValidatorIBAN alloc] init];
        [validators.validators addObject:validator];
    }
}

- (OPValidatorRegularExpression *)validatorRegularExpressionFromJSON:(NSDictionary *)rawValidator
{
    NSString *rawRegularExpression = [rawValidator objectForKey:@"regularExpression"];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:rawRegularExpression options:0 error:NULL];
    OPValidatorRegularExpression *validator = [[OPValidatorRegularExpression alloc] initWithRegularExpression:regularExpression];
    return validator;
}

- (OPValidatorRange *)validatorRangeFromJSON:(NSDictionary *)rawValidator
{
    OPValidatorRange *validator = [[OPValidatorRange alloc] init];
    validator.maxValue = [[rawValidator objectForKey:@"maxValue"] integerValue];
    validator.minValue = [[rawValidator objectForKey:@"minValue"] integerValue];
    return validator;
}

- (OPValidatorLength *)validatorLengthFromJSON:(NSDictionary *)rawValidator
{
    OPValidatorLength *validator = [[OPValidatorLength alloc] init];
    validator.maxLength = [[rawValidator objectForKey:@"maxLength"] integerValue];
    validator.minLength = [[rawValidator objectForKey:@"minLength"] integerValue];
    return validator;
}

- (OPValidatorFixedList *)validatorFixedListFromJSON:(NSDictionary *)rawValidator
{
    NSArray *rawValues = [rawValidator objectForKey:@"allowedValues"];
    NSMutableArray *allowedValues = [[NSMutableArray alloc] init];
    for (NSString *value in rawValues) {
        [allowedValues addObject:value];
    }
    OPValidatorFixedList *validator = [[OPValidatorFixedList alloc] initWithAllowedValues:allowedValues];
    return validator;
}

@end
