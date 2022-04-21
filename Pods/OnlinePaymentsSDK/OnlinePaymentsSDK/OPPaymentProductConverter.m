//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import  "OPPaymentProductConverter.h"

@implementation OPPaymentProductConverter

- (OPPaymentProduct *)paymentProductFromJSON:(NSDictionary *)rawProduct
{
    OPPaymentProduct *product = [[OPPaymentProduct alloc] init];
    [super setBasicPaymentProduct:product JSON:rawProduct];

    OPPaymentItemConverter *itemConverter = [OPPaymentItemConverter new];
    [itemConverter setPaymentProductFields:product.fields JSON:[rawProduct objectForKey:@"fields"]];
    return product;
}

@end
