//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPPaymentProductGroup.h"
#import "OPPaymentItemDisplayHints.h"
#import "OPAccountsOnFile.h"
#import "OPPaymentProductField.h"
#import "OPPaymentProductFields.h"

@implementation OPPaymentProductGroup

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[OPPaymentItemDisplayHints alloc] init];
        self.displayHintsList = [[NSMutableArray alloc] init];
        self.accountsOnFile = [[OPAccountsOnFile alloc] init];
        self.fields = [OPPaymentProductFields new];
    }
    return self;
}

- (OPAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier
{
    return [self.accountsOnFile accountOnFileWithIdentifier:accountOnFileIdentifier];
}

- (void)setStringFormatter:(OPStringFormatter *)stringFormatter
{
    for (OPAccountOnFile *accountOnFile in self.accountsOnFile.accountsOnFile) {
        accountOnFile.stringFormatter = stringFormatter;
    }
}

- (OPPaymentProductField *)paymentProductFieldWithId:(NSString *)paymentProductFieldId
{
    for (OPPaymentProductField *field in self.fields.paymentProductFields) {
        if ([field.identifier isEqualToString:paymentProductFieldId] == YES) {
            return field;
        }
    }
    return nil;
}

@end
