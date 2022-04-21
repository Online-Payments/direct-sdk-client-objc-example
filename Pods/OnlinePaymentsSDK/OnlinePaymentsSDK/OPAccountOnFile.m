//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPAccountOnFile.h"
#import "OPLabelTemplateItem.h"

@interface OPAccountOnFile ()

@property (strong, nonatomic) OPStringFormatter *stringFormatter;

@end

@implementation OPAccountOnFile

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[OPAccountOnFileDisplayHints alloc] init];
        self.attributes = [[OPAccountOnFileAttributes alloc] init];
    }
    return self;
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId
{
    NSString *mask = [self.displayHints.labelTemplate maskForAttributeKey:paymentProductFieldId];
    return [self maskedValueForField:paymentProductFieldId mask:mask];
}

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId mask:(NSString *)mask
{
    NSString *value = [self.attributes valueForField:paymentProductFieldId];
    if (mask == nil) {
        return value;
    } else {
        NSString *relaxedMask = [self.stringFormatter relaxMask:mask];
        return [self.stringFormatter formatString:value withMask:relaxedMask];
    }
}

- (BOOL)hasValueForField:(NSString *)paymentProductFieldId
{
    return [self.attributes hasValueForField:paymentProductFieldId];
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId
{
    return [self.attributes fieldIsReadOnly:paymentProductFieldId];
}

- (NSString *)label
{
    NSMutableArray *labelComponents = [[NSMutableArray alloc] init];
    for (OPLabelTemplateItem *labelTemplateItem in self.displayHints.labelTemplate.labelTemplateItems) {
        NSString *value = [self maskedValueForField:labelTemplateItem.attributeKey];
        if (value != nil && [value isEqualToString:@""] == NO) {
            NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [labelComponents addObject:trimmedValue];
        }
    }
    NSString *label = [labelComponents componentsJoinedByString:@" "];
    return label;
}

@end
