//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import  "OPBasicPaymentProductConverter.h"

@implementation OPBasicPaymentProductConverter

- (OPBasicPaymentProduct *)basicPaymentProductFromJSON:(NSDictionary *)rawBasicProduct
{
    OPBasicPaymentProduct *basicProduct = [[OPBasicPaymentProduct alloc] init];
    [self setBasicPaymentProduct:basicProduct JSON:rawBasicProduct];
    return basicProduct;
}

- (void)setBasicPaymentProduct:(OPBasicPaymentProduct *)basicProduct JSON:(NSDictionary *)rawBasicProduct
{
    [super setBasicPaymentItem:basicProduct JSON:rawBasicProduct];
    basicProduct.allowsRecurring = [[rawBasicProduct objectForKey:@"allowsRecurring"] boolValue];
    basicProduct.allowsTokenization = [[rawBasicProduct objectForKey:@"allowsTokenization"] boolValue];
    basicProduct.paymentMethod = [rawBasicProduct objectForKey:@"paymentMethod"];
    basicProduct.paymentProductGroup = [rawBasicProduct objectForKey:@"paymentProductGroup"];

    if (rawBasicProduct[@"paymentProduct302SpecificData"] != nil) {
        OPPaymentProduct302SpecificData *paymentProduct302SpecificData = [[OPPaymentProduct302SpecificData alloc] init];
        [self setPaymentProduct302SpecificData:paymentProduct302SpecificData JSON:[rawBasicProduct objectForKey:@"paymentProduct302SpecificData"]];
        basicProduct.paymentProduct302SpecificData = paymentProduct302SpecificData;
    }
}

- (void)setPaymentProduct302SpecificData:(OPPaymentProduct302SpecificData *)paymentProduct302SpecificData JSON:(NSDictionary *)rawPaymentProduct302SpecificData
{
    NSArray *rawNetworks = [rawPaymentProduct302SpecificData objectForKey:@"networks"];
    for (NSString *network in rawNetworks) {
        [paymentProduct302SpecificData.networks addObject:network];
    }
}

@end
