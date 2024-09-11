//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPTableSectionConverter.h"

#import "OPTableSectionConverter.h"
#import "OPPaymentProductsTableRow.h"

@import OnlinePaymentsKit;

@implementation OPTableSectionConverter

+ (OPPaymentProductsTableSection *)paymentProductsTableSectionFromAccountsOnFile:(NSArray *)accountsOnFile paymentItems:(OPPaymentItems *)paymentItems
{
    OPPaymentProductsTableSection *section = [[OPPaymentProductsTableSection alloc] init];
    section.type = OPAccountOnFileType;
    for (OPAccountOnFile *accountOnFile in accountsOnFile) {
        id<OPBasicPaymentItem> product = [paymentItems paymentItemWithIdentifier:accountOnFile.paymentProductIdentifier];
        OPPaymentProductsTableRow *row = [[OPPaymentProductsTableRow alloc] init];
        NSString *displayName = [accountOnFile label];
        row.name = displayName;
        row.accountOnFileIdentifier = accountOnFile.identifier;
        row.paymentProductIdentifier = accountOnFile.paymentProductIdentifier;
        if(product.displayHintsList != nil) {
            row.logo = product.displayHintsList[0].logoImage ?: nil;
        }
        [section.rows addObject:row];
    }
    return section;
}

+ (OPPaymentProductsTableSection *)paymentProductsTableSectionFromPaymentItems:(OPPaymentItems *)paymentItems
{
    OPPaymentProductsTableSection *section = [[OPPaymentProductsTableSection alloc] init];
    for (NSObject<OPPaymentItem> *paymentItem in paymentItems.paymentItems) {
        section.type = OPPaymentProductType;
        OPPaymentProductsTableRow *row = [[OPPaymentProductsTableRow alloc] init];
        if(paymentItem.displayHintsList != nil) {
            row.name = paymentItem.displayHintsList[0].label ?: @"No label found";
            row.logo = paymentItem.displayHintsList[0].logoImage ?: nil;
        } else {
            row.name = @"Display hints not found";
            row.logo = nil;
        }
        
        row.accountOnFileIdentifier = @"";
        row.paymentProductIdentifier = paymentItem.identifier;
        [section.rows addObject:row];
    }
    return section;
}

@end
