//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPBasicPaymentProductGroup.h"
#import "OPPaymentItemDisplayHints.h"
#import "OPAccountsOnFile.h"

@implementation OPBasicPaymentProductGroup

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.displayHints = [[OPPaymentItemDisplayHints alloc] init];
        self.displayHintsList = [[NSMutableArray alloc] init];
        self.accountsOnFile = [[OPAccountsOnFile alloc] init];
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

@end
