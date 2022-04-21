//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPDisplayElementsConverter.h"
#import "OPDisplayElement.h"

@implementation OPDisplayElementsConverter

// TODO type
-(NSArray<OPDisplayElement *> *)displayElementsFromJSON:(NSArray *)json
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in json)
    {
        [arr addObject:[self displayElementFromJSON:dict]];
    }
    return arr;
}

-(OPDisplayElement *)displayElementFromJSON:(NSDictionary *)dict
{
    OPDisplayElement *element = [[OPDisplayElement alloc]init];
    element.identifier = dict[@"id"];
    element.value = dict[@"value"];
    NSString *elementType = dict[@"type"];
    if ([elementType isEqualToString:@"STRING"]) {
        element.type = OPDisplayElementTypeString;
    }
    else if ([elementType isEqualToString:@"CURRENCY"])
    {
        element.type = OPDisplayElementTypeCurrency;

    }
    else if ([elementType isEqualToString:@"PERCENTAGE"])
    {
        element.type = OPDisplayElementTypePercentage;

    }
    else if ([elementType isEqualToString:@"URI"])
    {
        element.type = OPDisplayElementTypeURI;

    }
    else if ([elementType isEqualToString:@"INTEGER"])
    {
        element.type = OPDisplayElementTypeInteger;

    }

    return element;
    
}

@end
