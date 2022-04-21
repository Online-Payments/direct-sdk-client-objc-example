//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPAccountOnFileAttributes.h"
#import "OPAccountOnFileAttribute.h"

@implementation OPAccountOnFileAttributes

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.attributes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)valueForField:(NSString *)paymentProductFieldId
{
    for (OPAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return attribute.value;
        }
    }
    return @"";
}

- (BOOL)hasValueForField:(NSString *)paymentProductFieldId
{
    for (OPAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId
{
    for (OPAccountOnFileAttribute *attribute in self.attributes) {
        if ([attribute.key isEqualToString:paymentProductFieldId] == YES) {
            return attribute.status == OPReadOnly;
        }
    }
    return NO;
}

@end
