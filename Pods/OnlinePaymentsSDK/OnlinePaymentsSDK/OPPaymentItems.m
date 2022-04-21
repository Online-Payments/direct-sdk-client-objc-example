//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPPaymentItems.h"
#import "OPBasicPaymentItem.h"
#import "OPStringFormatter.h"
#import "OPPaymentItemDisplayHints.h"
#import "OPAccountsOnFile.h"
#import "OPBasicPaymentProductGroups.h"
#import "OPBasicPaymentProducts.h"
#import "OPPaymentProductGroup.h"

@interface OPPaymentItems ()

@property (strong, nonatomic) OPStringFormatter *stringFormatter;
@property (nonatomic, strong) NSArray *allPaymentItems;

@end

@implementation OPPaymentItems

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentItems = [[NSMutableArray alloc] init];
        self.allPaymentItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithPaymentProducts:(OPBasicPaymentProducts *)products groups:(OPBasicPaymentProductGroups *)groups {
    self = [self init];
    if (self != nil) {
        self.paymentItems = [NSMutableArray arrayWithArray:[self createPaymentItemsFromProducts:products groups:groups]];
        self.allPaymentItems = products.paymentProducts;
                
    }
    return self;
}

-(NSArray *)createPaymentItemsFromProducts:(OPBasicPaymentProducts *)products groups:(OPBasicPaymentProductGroups *)groups {
    return products.paymentProducts;
}

- (BOOL)hasAccountsOnFile
{
    for (NSObject<OPBasicPaymentItem> *paymentItem in self.paymentItems) {
        if (paymentItem.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (NSObject<OPBasicPaymentItem> *paymentItem in self.paymentItems) {
        [accountsOnFile addObjectsFromArray:paymentItem.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentItem:(NSString *)paymentItemIdentifier
{
    NSObject<OPBasicPaymentItem> *paymentItem = [self paymentItemWithIdentifier:paymentItemIdentifier];
    
    if (paymentItem.displayHintsList.count > 0) {
        return paymentItem.displayHintsList[0].logoPath;
    }else {
        return nil;
    }
}

- (NSObject<OPBasicPaymentItem> *)paymentItemWithIdentifier:(NSString *)paymentItemIdentifier
{
    for (NSObject<OPBasicPaymentItem> *paymentItem in self.allPaymentItems) {
        if ([paymentItem.identifier isEqualToString:paymentItemIdentifier] == YES) {
            return paymentItem;
        }
    }
    return nil;
}

- (void)sort
{
    [self.paymentItems sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject<OPBasicPaymentItem> *paymentItem1 = (NSObject<OPBasicPaymentItem> *)obj1;
        NSObject<OPBasicPaymentItem> *paymentItem2 = (NSObject<OPBasicPaymentItem> *)obj2;
        
        if (paymentItem1.displayHintsList.count <= 0 || paymentItem2.displayHintsList.count <=0) {
            return NSOrderedSame;
        }
        
        if (paymentItem1.displayHintsList[0].displayOrder > paymentItem2.displayHintsList[0].displayOrder) {
            return NSOrderedDescending;
        }
        if (paymentItem1.displayHintsList[0].displayOrder < paymentItem2.displayHintsList[0].displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
