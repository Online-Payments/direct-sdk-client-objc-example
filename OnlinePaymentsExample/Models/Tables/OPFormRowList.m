//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPFormRowList.h"

@implementation OPFormRowList

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull OPPaymentProductField *)paymentProductField {
    self = [super init];
    
    if (self) {
        self.items = [[NSMutableArray alloc]init];
        self.paymentProductField = paymentProductField;
    }
    
    return self;
}

@end
