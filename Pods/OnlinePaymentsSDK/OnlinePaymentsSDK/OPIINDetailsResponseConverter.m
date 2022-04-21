//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import  "OPIINDetailsResponseConverter.h"
#import  "OPIINDetail.h"

@implementation OPIINDetailsResponseConverter

- (OPIINDetailsResponse *)IINDetailsResponseFromJSON:(NSDictionary *)rawIINDetailsResponse {
    NSNumber *paymentProductIdNumber = rawIINDetailsResponse[@"paymentProductId"];
    NSString *paymentProductId = [NSString stringWithFormat:@"%@", paymentProductIdNumber];
    NSString *countryCode = rawIINDetailsResponse[@"countryCode"];
    BOOL allowedInContext = NO;
    if (rawIINDetailsResponse[@"isAllowedInContext"] != nil) {
        allowedInContext = [rawIINDetailsResponse[@"isAllowedInContext"] boolValue];
    }
    NSArray *coBrands = [self IINDetailsFromJSON:rawIINDetailsResponse[@"coBrands"]];
    
    if (paymentProductIdNumber == nil) {
        return [[OPIINDetailsResponse  alloc] initWithStatus:OPUnknown];
    }
    else if (allowedInContext == NO) {
        return [[OPIINDetailsResponse  alloc] initWithStatus:OPExistingButNotAllowed];
    }
    else {
        OPIINDetailsResponse *response = [[OPIINDetailsResponse alloc] initWithPaymentProductId:paymentProductId
                                                                                         status:OPSupported
                                                                                       coBrands:coBrands
                                                                                    countryCode:countryCode
                                                                               allowedInContext:allowedInContext];
        return response;
    }
}

- (NSArray *)IINDetailsFromJSON:(NSArray *)IINDetailsArray {
    NSMutableArray *IINDetails = [[NSMutableArray alloc] init];
    for (NSDictionary *rawIINDetail in IINDetailsArray) {
        [IINDetails addObject:[self IINDetailFromJSON:rawIINDetail]];
    }
    return [NSArray arrayWithArray:IINDetails];
}

- (OPIINDetail *)IINDetailFromJSON:(NSDictionary *)rawIINDetail {
    NSString *paymentProductId = [NSString stringWithFormat:@"%@", rawIINDetail[@"paymentProductId"]];
    BOOL allowedInContext = NO;
    if (rawIINDetail[@"isAllowedInContext"] != nil) {
        allowedInContext = [rawIINDetail[@"isAllowedInContext"] boolValue];
    }
    OPIINDetail *detail = [[OPIINDetail alloc] initWithPaymentProductId:paymentProductId allowedInContext:allowedInContext];
    return detail;
}

@end
