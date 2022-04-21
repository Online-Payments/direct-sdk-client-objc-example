//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPPaymentProduct.h"

@implementation OPPaymentProduct

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.fields = [[OPPaymentProductFields alloc] init];
    }
    return self;
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
