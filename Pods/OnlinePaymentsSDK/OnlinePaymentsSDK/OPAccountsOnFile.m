//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPAccountsOnFile.h"

@implementation OPAccountsOnFile

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.accountsOnFile = [[NSMutableArray alloc] init];
    }
    return self;
}

- (OPAccountOnFile *)accountOnFileWithIdentifier:(NSString *)accountOnFileIdentifier
{
    for (OPAccountOnFile *accountOnFile in self.accountsOnFile) {
        if ([accountOnFile.identifier isEqualToString:accountOnFileIdentifier] == YES) {
            return accountOnFile;
        }
    }
    return nil;
}

@end
