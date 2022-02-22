//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPFormRowsConverter.h"
#import "OPFormRowDate.h"
#import "OPFormRowsConverter.h"
#import "OPFormRowList.h"
#import "OPFormRowTextField.h"
#import "OPFormRowSwitch.h"
#import "OPPaymentProductInputData.h"
#import "OPFormRowCurrency.h"
#import "OPFormRowLabel.h"

#import <OnlinePaymentsSDK/OPIINDetailsResponse.h>
#import <OnlinePaymentsSDK/OPSDKConstants.h>
#import <OnlinePaymentsSDK/OPValidators.h>
#import <OnlinePaymentsSDK/OPValidationErrorAllowed.h>
#import <OnlinePaymentsSDK/OPValidationErrorIBAN.h>
#import <OnlinePaymentsSDK/OPValidationErrorLuhn.h>
#import <OnlinePaymentsSDK/OPValidationErrorLength.h>
#import <OnlinePaymentsSDK/OPValidationErrorRegularExpression.h>
#import <OnlinePaymentsSDK/OPValidationErrorTermsAndConditions.h>
#import <OnlinePaymentsSDK/OPValidationErrorIsRequired.h>
#import <OnlinePaymentsSDK/OPValidationErrorFixedList.h>
#import <OnlinePaymentsSDK/OPValidationErrorRange.h>
#import <OnlinePaymentsSDK/OPValidationErrorExpirationDate.h>
#import <OnlinePaymentsSDK/OPValidationErrorEmailAddress.h>

@interface OPFormRowsConverter ()

+ (NSBundle *)sdkBundle;

@end

@implementation OPFormRowsConverter

static NSBundle * _sdkBundle;
+ (NSBundle *)sdkBundle {
    if (_sdkBundle == nil) {
        _sdkBundle = [NSBundle bundleWithPath:kOPSDKBundlePath];
    }
    return _sdkBundle;
}

- (instancetype)init
{
    self = [super init];
    
    return self;
}

- (NSMutableArray *)formRowsFromInputData:(OPPaymentProductInputData *)inputData viewFactory:(OPViewFactory *)viewFactory confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts {
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    for (OPPaymentProductField* field in inputData.paymentItem.fields.paymentProductFields) {
        OPFormRow *row;
        BOOL isPartOfAccountOnFile = [inputData fieldIsPartOfAccountOnFile:field.identifier];
        NSString *value;
        BOOL isEnabled;
        if (isPartOfAccountOnFile == YES) {
            NSString *mask = field.displayHints.mask;
            value = [inputData.accountOnFile maskedValueForField:field.identifier mask:mask];
            isEnabled = [inputData fieldIsReadOnly:field.identifier] == NO;
        } else {
            value = [inputData maskedValueForField:field.identifier];
            isEnabled = YES;
        }
        row = [self labelFormRowFromField:field paymentProduct:inputData.paymentItem.identifier viewFactory:viewFactory];
        [rows addObject:row];
        switch (field.displayHints.formElement.type) {
            case OPListType: {
                row = [self listFormRowFromField:field value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            case OPTextType: {
                row = [self textFieldFormRowFromField:field paymentItem:inputData.paymentItem value:value isEnabled:isEnabled confirmedPaymentProducts:confirmedPaymentProducts viewFactory:viewFactory];
                break;
            }
            case OPBoolType: {
                [rows removeLastObject]; // Label is integrated into switch field
                row = [self switchFormRowFromField: field paymentItem: inputData.paymentItem value: value isEnabled: isEnabled viewFactory: viewFactory];
                break;
            }
            case OPDateType: {
                row = [self dateFormRowFromField: field paymentItem: inputData.paymentItem value: value isEnabled: isEnabled viewFactory: viewFactory];
                break;

            }
            case OPCurrencyType: {
                row = [self currencyFormRowFromField:field paymentItem:inputData.paymentItem value:value isEnabled:isEnabled viewFactory:viewFactory];
                break;
            }
            default: {
                [NSException raise:@"Invalid form element type" format:@"Form element type %d is invalid", field.displayHints.formElement.type];
                break;
            }
        }
        [rows addObject:row];
    }
    return rows;
}

- (OPValidationError *)errorWithIINDetails:(OPIINDetailsResponse *)iinDetailsResponse {
    //Validation error
    if (iinDetailsResponse.status == OPExistingButNotAllowed) {
        return [OPValidationErrorAllowed new];
    } else if (iinDetailsResponse.status == OPUnknown) {
        return [OPValidationErrorLuhn new];
    }
    return nil;
}

+ (NSString *)errorMessageForError:(OPValidationError *)error withCurrency:(BOOL)forCurrency
{
    Class errorClass = [error class];
    NSString *errorMessageFormat = @"gc.general.paymentProductFields.validationErrors.%@.label";
    NSString *errorMessageKey;
    NSString *errorMessageValue;
    NSString *errorMessage;
    if (errorClass == [OPValidationErrorLength class]) {
        OPValidationErrorLength *lengthError = (OPValidationErrorLength *)error;
        if (lengthError.minLength == lengthError.maxLength) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.exact"];
        } else if (lengthError.minLength == 0 && lengthError.maxLength > 0) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.max"];
        } else if (lengthError.minLength > 0 && lengthError.maxLength > 0) {
            errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.between"];
        }
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, self.sdkBundle, nil);
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{maxLength}" withString:[NSString stringWithFormat:@"%ld", lengthError.maxLength]];
        errorMessage = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{minLength}" withString:[NSString stringWithFormat:@"%ld", lengthError.minLength]];
    } else if (errorClass == [OPValidationErrorRange class]) {
        OPValidationErrorRange *rangeError = (OPValidationErrorRange *)error;
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"length.between"];
        NSString *errorMessageValueWithPlaceholders = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, self.sdkBundle, nil);
        NSString *minString;
        NSString *maxString;
        if (forCurrency == YES) {
            minString = [NSString stringWithFormat:@"%.2f", (double)rangeError.minValue / 100];
            maxString = [NSString stringWithFormat:@"%.2f", (double)rangeError.maxValue / 100];
        } else {
            minString = [NSString stringWithFormat:@"%ld", (long)rangeError.minValue];
            maxString = [NSString stringWithFormat:@"%ld", (long)rangeError.maxValue];
        }
        NSString *errorMessageValueWithPlaceholder = [errorMessageValueWithPlaceholders stringByReplacingOccurrencesOfString:@"{minValue}" withString:minString];
        errorMessageValue = [errorMessageValueWithPlaceholder stringByReplacingOccurrencesOfString:@"{maxValue}" withString:maxString];
    } else if (errorClass == [OPValidationErrorExpirationDate class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"expirationDate"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorFixedList class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"fixedList"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorLuhn class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"luhn"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorAllowed class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"allowedInContext"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorEmailAddress class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"emailAddress"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorIBAN class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"regularExpression"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorRegularExpression class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"regularExpression"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorTermsAndConditions class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"termsAndConditions"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else if (errorClass == [OPValidationErrorIsRequired class]) {
        errorMessageKey = [NSString stringWithFormat:errorMessageFormat, @"required"];
        errorMessageValue = NSLocalizedStringFromTableInBundle(errorMessageKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        errorMessage = errorMessageValue;
    } else {
        [NSException raise:@"Invalid validation error" format:@"Validation error %@ is invalid", error];
    }
    return errorMessage;
}
- (OPFormRowTextField *)textFieldFormRowFromField:(OPPaymentProductField *)field paymentItem:(NSObject<OPPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled confirmedPaymentProducts:(NSSet *)confirmedPaymentProducts viewFactory:(OPViewFactory *)viewFactory
{
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.placeholder", paymentItem.identifier, field.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
    }
    
    UIKeyboardType keyboardType = UIKeyboardTypeDefault;
    if (field.displayHints.preferredInputType == OPIntegerKeyboard) {
        keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == OPEmailAddressKeyboard) {
        keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == OPPhoneNumberKeyboard) {
        keyboardType = UIKeyboardTypePhonePad;
    }
    
    OPFormRowField *formField = [[OPFormRowField alloc] initWithText:value placeholder:placeholderValue keyboardType:keyboardType isSecure:field.displayHints.obfuscate];
    OPFormRowTextField *row = [[OPFormRowTextField alloc] initWithPaymentProductField:field field:formField];
    row.isEnabled = isEnabled;
    
    if ([field.identifier isEqualToString:@"cardNumber"] == YES) {
        if ([confirmedPaymentProducts member:paymentItem.identifier] != nil) {
            row.logo = paymentItem.displayHints.logoImage;
        }
        else {
            row.logo = nil;
        }
    }
    
    [self setTooltipForFormRow:row withField:field paymentItem:paymentItem];
    
    return row;
}

- (OPFormRowSwitch *)switchFormRowFromField:(OPPaymentProductField *)field paymentItem:(NSObject<OPPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(OPViewFactory *)viewFactory
{
    NSString *descriptionKey = [NSString stringWithFormat: @"gc.general.paymentProducts.%@.paymentProductFields.%@.label", paymentItem.identifier, field.identifier];
    NSString *descriptionValue = NSLocalizedStringWithDefaultValue(descriptionKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil, @"Accept {link}");
    NSString *labelKey = [NSString stringWithFormat: @"gc.general.paymentProducts.%@.paymentProductFields.%@.link.label", paymentItem.identifier, field.identifier];
    NSString *labelValue = NSLocalizedStringWithDefaultValue(labelKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil, @"");
    NSRange range = [descriptionValue rangeOfString:@"{link}"];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:descriptionValue];
    NSAttributedString *linkString = [[NSAttributedString alloc]initWithString:labelValue attributes:@{NSLinkAttributeName:field.displayHints.link.absoluteString}];
    [attrString replaceCharactersInRange:range withAttributedString:linkString];

    OPFormRowSwitch *row = [[OPFormRowSwitch alloc] initWithAttributedTitle:attrString isOn:[value isEqualToString:@"true"] target:nil action:NULL paymentProductField:field];
    row.isEnabled = isEnabled;

    return row;
}

- (OPFormRowDate *)dateFormRowFromField:(OPPaymentProductField *)field paymentItem:(NSObject<OPPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(OPViewFactory *)viewFactory
{
    OPFormRowDate *row = [[OPFormRowDate alloc] init];
    row.paymentProductField = field;
    row.isEnabled = isEnabled;
    row.value = value;
    return row;
}

- (OPFormRowCurrency *)currencyFormRowFromField:(OPPaymentProductField *)field paymentItem:(NSObject<OPPaymentItem> *)paymentItem value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(OPViewFactory *)viewFactory
{
    NSString *placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.placeholder", paymentItem.identifier, field.identifier];
    NSString *placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
    if ([placeholderKey isEqualToString:placeholderValue] == YES) {
        placeholderKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.placeholder", field.identifier];
        placeholderValue = NSLocalizedStringFromTableInBundle(placeholderKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
    }
    
    OPFormRowCurrency *row = [[OPFormRowCurrency alloc] init];
    row.integerField = [[OPFormRowField alloc] init];
    row.fractionalField = [[OPFormRowField alloc] init];
    
    row.integerField.placeholder = placeholderValue;
    if (field.displayHints.preferredInputType == OPIntegerKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypeNumberPad;
        row.fractionalField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (field.displayHints.preferredInputType == OPEmailAddressKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypeEmailAddress;
        row.fractionalField.keyboardType = UIKeyboardTypeEmailAddress;
    } else if (field.displayHints.preferredInputType == OPPhoneNumberKeyboard) {
        row.integerField.keyboardType = UIKeyboardTypePhonePad;
        row.fractionalField.keyboardType = UIKeyboardTypePhonePad;
    }
    
    long long integerPart = [value longLongValue] / 100;
    int fractionalPart = (int) llabs([value longLongValue] % 100);
    row.integerField.isSecure = field.displayHints.obfuscate;
    row.integerField.text = [NSString stringWithFormat:@"%lld", integerPart];
    row.fractionalField.isSecure = field.displayHints.obfuscate;
    row.fractionalField.text = [NSString stringWithFormat:@"%02d", fractionalPart];
    row.paymentProductField = field;

    row.isEnabled = isEnabled;
    [self setTooltipForFormRow:row withField:field paymentItem:paymentItem];
    
    return row;
}

- (void)setTooltipForFormRow:(OPFormRowWithInfoButton *)row withField:(OPPaymentProductField *)field paymentItem:(NSObject<OPPaymentItem> *)paymentItem
{
    if (field.displayHints.tooltip.imagePath != nil) {
        OPFormRowTooltip *tooltip = [OPFormRowTooltip new];
        NSString *tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.tooltipText", paymentItem.identifier, field.identifier];
        NSString *tooltipTextValue = NSLocalizedStringFromTableInBundle(tooltipTextKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        if ([tooltipTextKey isEqualToString:tooltipTextValue] == YES) {
            tooltipTextKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.tooltipText", field.identifier];
            tooltipTextValue = NSLocalizedStringFromTableInBundle(tooltipTextKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
        }
        tooltip.text = tooltipTextValue;
        tooltip.image = field.displayHints.tooltip.image;
        row.tooltip = tooltip;
    }
}

- (OPFormRowList *)listFormRowFromField:(OPPaymentProductField *)field value:(NSString *)value isEnabled:(BOOL)isEnabled viewFactory:(OPViewFactory *)viewFactory
{
    OPFormRowList *row = [[OPFormRowList alloc] initWithPaymentProductField:field];
    
    NSInteger rowIndex = 0;
    NSInteger selectedRow = 0;
    for (OPValueMappingItem *item in field.displayHints.formElement.valueMapping) {
        if (item.value != nil) {
            if ([item.value isEqualToString:value]) {
                selectedRow = rowIndex;
            }
            [row.items addObject:item];
        }
        ++rowIndex;
    }

    row.selectedRow = selectedRow;
    row.isEnabled = isEnabled;
    return row;
}
- (NSString *)labelStringFormRowFromField:(OPPaymentProductField *)field paymentProduct:(NSString *)paymentProductId {
    NSString *labelKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.paymentProductFields.%@.label", paymentProductId, field.identifier];
    NSString *labelValue = NSLocalizedStringFromTableInBundle(labelKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
    if ([labelKey isEqualToString:labelValue] == YES) {
        labelKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.label", field.identifier];
        labelValue = NSLocalizedStringFromTableInBundle(labelKey, kOPSDKLocalizable, [OPFormRowsConverter sdkBundle], nil);
    }
    return labelValue;
}
- (OPFormRowLabel *)labelFormRowFromField:(OPPaymentProductField *)field paymentProduct:(NSString *)paymentProductId viewFactory:(OPViewFactory *)viewFactory
{
    OPFormRowLabel *row = [[OPFormRowLabel alloc] init];
    NSString *labelValue = [self labelStringFormRowFromField:field paymentProduct:paymentProductId];
    row.text = labelValue;
    
    return row;
}

@end
