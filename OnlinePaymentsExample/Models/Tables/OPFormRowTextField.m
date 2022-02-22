//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPFormRowTextField.h"

@implementation OPFormRowTextField

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull OPPaymentProductField *)paymentProductField field: (nonnull OPFormRowField*)field {
    self = [super init];
    
    if (self) {
        self.paymentProductField = paymentProductField;
        self.field = field;
    }
    
    return self;
}

@end
