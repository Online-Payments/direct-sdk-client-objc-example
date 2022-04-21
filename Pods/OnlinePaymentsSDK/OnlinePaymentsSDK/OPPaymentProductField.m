//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPPaymentProductField.h"
#import "OPValidator.h"
#import "OPValidationErrorIsRequired.h"
#import "OPValidationErrorInteger.h"
#import "OPValidationErrorNumericString.h"

@interface OPPaymentProductField ()

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) NSRegularExpression *numericStringCheck;

@end

@implementation OPPaymentProductField

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.dataRestrictions = [[OPDataRestrictions alloc] init];
        self.displayHints = [[OPPaymentProductFieldDisplayHints alloc] init];
        self.errors = [[NSMutableArray alloc] init];
        self.numericStringCheck = [[NSRegularExpression alloc] initWithPattern:@"^\\d+$" options:0 error:nil];
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)validateValue:(NSString *)value
{
    NSLog(@"validateValue: is deprecated! please use validateValue:forPaymentRequest: instead");
    [self validateValue:value forPaymentRequest:nil];
}

- (void)validateValue:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request
{
    [self.errors removeAllObjects];
    if (self.dataRestrictions.isRequired == YES && [value isEqualToString:@""] == YES) {
        OPValidationErrorIsRequired *error = [[OPValidationErrorIsRequired alloc] init];
        [self.errors addObject:error];
    } else if (self.dataRestrictions.isRequired == YES || [value isEqualToString:@""] == NO || self.dataRestrictions.validators.containsSomeTimesRequiredValidator) {
        for (OPValidator *rule in self.dataRestrictions.validators.validators) {
            [rule validate:value forPaymentRequest:request];
            [self.errors addObjectsFromArray:rule.errors];
        }
        switch (self.type) {
            case OPExpirationDate:
                break;
            case OPInteger: {
                NSNumber *number = [self.numberFormatter numberFromString:value];
                if (number == nil) {
                    OPValidationErrorInteger *error = [[OPValidationErrorInteger alloc] init];
                    [self.errors addObject:error];
                }
                break;
            }
            case OPNumericString: {
                if ([self.numericStringCheck numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)] != 1) {
                    OPValidationErrorNumericString *error = [[OPValidationErrorNumericString alloc] init];
                    [self.errors addObject:error];
                }
                break;
            }
            case OPString:
                break;
            case OPBooleanString:
                break;
            case OPDateString:
                break;
            default:
                [NSException raise:@"Invalid type" format:@"Type %u is invalid", self.type];
                break;
        }
    }
}

@end
