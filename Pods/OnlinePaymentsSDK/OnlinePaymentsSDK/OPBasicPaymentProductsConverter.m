//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import  "OPBasicPaymentProductsConverter.h"
#import  "OPBasicPaymentProductConverter.h"

@implementation OPBasicPaymentProductsConverter

- (OPBasicPaymentProducts *)paymentProductsFromJSON:(NSArray *)rawProducts
{
    OPBasicPaymentProducts *products = [[OPBasicPaymentProducts alloc] init];
    OPBasicPaymentProductConverter *converter = [[OPBasicPaymentProductConverter alloc] init];
    for (NSDictionary *rawProduct in rawProducts) {
        OPBasicPaymentProduct *product = [converter basicPaymentProductFromJSON:rawProduct];
        [products.paymentProducts addObject:product];
    }
    [products sort];
    return products;
}

@end
