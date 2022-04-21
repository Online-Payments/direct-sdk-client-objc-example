//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPPaymentProductFields.h"
#import "OPPaymentProductField.h"

@implementation OPPaymentProductFields

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProductFields = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)sort
{
    [self.paymentProductFields sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        OPPaymentProductField *field1 = (OPPaymentProductField *)obj1;
        OPPaymentProductField *field2 = (OPPaymentProductField *)obj2;
        if (field1.displayHints.displayOrder > field2.displayHints.displayOrder) {
            return NSOrderedDescending;
        }
        if (field1.displayHints.displayOrder < field2.displayHints.displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
