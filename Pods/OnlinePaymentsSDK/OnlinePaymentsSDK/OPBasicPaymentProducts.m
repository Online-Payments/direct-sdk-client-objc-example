//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import  "OPBasicPaymentProducts.h"

@interface OPBasicPaymentProducts ()

@property (strong, nonatomic) OPStringFormatter *stringFormatter;

@end

@implementation OPBasicPaymentProducts

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProducts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasAccountsOnFile
{
    for (OPBasicPaymentProduct *product in self.paymentProducts) {
        if (product.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (OPBasicPaymentProduct *product in self.paymentProducts) {
        [accountsOnFile addObjectsFromArray:product.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentProduct:(NSString *)paymentProductIdentifier
{
    OPBasicPaymentProduct *product = [self paymentProductWithIdentifier:paymentProductIdentifier];
    
    if (product.displayHintsList.count > 0) {
        return product.displayHintsList[0].logoPath;
    }else{
        return nil;
    }
    
}

- (OPBasicPaymentProduct *)paymentProductWithIdentifier:(NSString *)paymentProductIdentifier
{
    for (OPBasicPaymentProduct *product in self.paymentProducts) {
        if ([product.identifier isEqualToString:paymentProductIdentifier] == YES) {
            return product;
        }
    }
    return nil;
}

- (void)setStringFormatter:(OPStringFormatter *)stringFormatter
{
    for (OPBasicPaymentProduct *basicProduct in self.paymentProducts) {
        [basicProduct setStringFormatter:stringFormatter];
    }
}

- (void)sort
{
    [self.paymentProducts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        OPBasicPaymentProduct *product1 = (OPBasicPaymentProduct *)obj1;
        OPBasicPaymentProduct *product2 = (OPBasicPaymentProduct *)obj2;
        
        if (product1.displayHintsList.count <= 0 || product2.displayHintsList.count <=0) {
            return NSOrderedSame;
        }
        
        if (product1.displayHintsList[0].displayOrder > product2.displayHintsList[0].displayOrder) {
            return NSOrderedDescending;
        }
        if (product1.displayHintsList[0].displayOrder < product2.displayHintsList[0].displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
