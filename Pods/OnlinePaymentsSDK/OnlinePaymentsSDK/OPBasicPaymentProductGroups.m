//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPBasicPaymentProductGroups.h"
#import "OPStringFormatter.h"
#import "OPAccountsOnFile.h"
#import "OPPaymentItemDisplayHints.h"
#import "OPBasicPaymentProductGroup.h"

@interface OPBasicPaymentProductGroups ()

@property (strong, nonatomic) OPStringFormatter *stringFormatter;

@end

@implementation OPBasicPaymentProductGroups

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        self.paymentProductGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasAccountsOnFile
{
    for (OPBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        if (productGroup.accountsOnFile.accountsOnFile.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)accountsOnFile
{
    NSMutableArray *accountsOnFile = [[NSMutableArray alloc] init];
    for (OPBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        [accountsOnFile addObjectsFromArray:productGroup.accountsOnFile.accountsOnFile];
    }
    return accountsOnFile;
}

- (NSString *)logoPathForPaymentProductGroup:(NSString *)paymentProductGroupIdentifier
{
    OPBasicPaymentProductGroup *productGroup = [self paymentProductGroupWithIdentifier:paymentProductGroupIdentifier];
    if (productGroup.displayHintsList.count > 0) {
        return productGroup.displayHintsList[0].logoPath;
    }else {
        return nil;
    }
}

- (OPBasicPaymentProductGroup *)paymentProductGroupWithIdentifier:(NSString *)paymentProductGroupIdentifier
{
    for (OPBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        if ([productGroup.identifier isEqualToString:paymentProductGroupIdentifier] == YES) {
            return productGroup;
        }
    }
    return nil;
}

- (void)setStringFormatter:(OPStringFormatter *)stringFormatter
{
    for (OPBasicPaymentProductGroup *productGroup in self.paymentProductGroups) {
        [productGroup setStringFormatter:stringFormatter];
    }
}

- (void)sort
{
    [self.paymentProductGroups sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        OPBasicPaymentProductGroup *productGroup1 = (OPBasicPaymentProductGroup *)obj1;
        OPBasicPaymentProductGroup *productGroup2 = (OPBasicPaymentProductGroup *)obj2;
        
        if (productGroup1.displayHintsList.count <= 0 || productGroup2.displayHintsList.count <=0) {
            return NSOrderedSame;
        }
        
        if (productGroup1.displayHintsList[0].displayOrder > productGroup2.displayHintsList[0].displayOrder) {
            return NSOrderedDescending;
        }
        if (productGroup1.displayHintsList[0].displayOrder < productGroup2.displayHintsList[0].displayOrder) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

@end
