//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import  "OPBasicPaymentItemConverter.h"
#import  "OPValidator.h"
#import  "OPBasicPaymentItem.h"
#import  "OPMacros.h"
#import  "OPBasicPaymentProductConverter.h"
#import  "OPAccountOnFileAttribute.h"
#import  "OPLabelTemplateItem.h"

@implementation OPBasicPaymentItemConverter

- (void)setBasicPaymentItem:(NSObject <OPBasicPaymentItem> *)paymentItem JSON:(NSDictionary *)rawPaymentItem {
    NSObject *identifier = [rawPaymentItem objectForKey:@"id"];
    if ([identifier isKindOfClass:[NSString class]]) {
        paymentItem.identifier = (NSString *) identifier;
    } else if ([identifier isKindOfClass:[NSNumber class]]) {
        paymentItem.identifier = [(NSNumber *)identifier stringValue];
    }

    [self setPaymentProductDisplayHints:paymentItem.displayHints JSON:[rawPaymentItem objectForKey:@"displayHints"]];
    [self setPaymentProductDisplayHintsList:paymentItem.displayHintsList JSON:[rawPaymentItem objectForKey:@"displayHintsList"]];
    [self setAccountsOnFile:paymentItem.accountsOnFile JSON:[rawPaymentItem objectForKey:@"accountsOnFile"]];
}

- (void)setPaymentProductDisplayHints:(OPPaymentItemDisplayHints *)displayHints JSON:(NSDictionary *)rawDisplayHints
{
    displayHints.displayOrder = [[rawDisplayHints objectForKey:@"displayOrder"] integerValue];
    displayHints.logoPath = [rawDisplayHints objectForKey:@"logo"];
}

- (void)setPaymentProductDisplayHintsList:(NSMutableArray<OPPaymentItemDisplayHints *> *)displayHintsList JSON:(NSArray *)rawDisplayHintsList
{
    for (NSDictionary *rawDisplayHints in rawDisplayHintsList) {
        OPPaymentItemDisplayHints *displayHints = [[OPPaymentItemDisplayHints alloc] init];
        [self setPaymentProductDisplayHints:displayHints JSON:rawDisplayHints];
        [displayHintsList addObject:displayHints];
    }
}

- (void)setAccountsOnFile:(OPAccountsOnFile *)accountsOnFile JSON:(NSArray *)rawAccounts
{
    for (NSDictionary *rawAccount in rawAccounts) {
        OPAccountOnFile *account = [self accountOnFileFromJSON:rawAccount];
        [accountsOnFile.accountsOnFile addObject:account];
    }
}

- (OPAccountOnFile *)accountOnFileFromJSON:(NSDictionary *)rawAccount
{
    OPAccountOnFile *account = [[OPAccountOnFile alloc] init];
    account.identifier = [[rawAccount objectForKey:@"id"] stringValue];
    account.paymentProductIdentifier = [[rawAccount objectForKey:@"paymentProductId"] stringValue];
    [self setAccountOnFileDisplayHints:account.displayHints JSON:[rawAccount objectForKey:@"displayHints"]];
    [self setAttributes:account.attributes JSON:[rawAccount objectForKey:@"attributes"]];
    return account;
}

- (void)setAccountOnFileDisplayHints:(OPAccountOnFileDisplayHints *)displayHints JSON:(NSDictionary *)rawDisplayHints
{
    [self setLabelTemplate:displayHints.labelTemplate JSON:[rawDisplayHints objectForKey:@"labelTemplate"]];
}

- (void)setLabelTemplate:(OPLabelTemplate *)labelTemplate JSON:(NSArray *)rawLabelTemplate
{
    for (NSDictionary *rawLabelTemplateItem in rawLabelTemplate) {
        OPLabelTemplateItem *item = [self labelTemplateItemFromJSON:rawLabelTemplateItem];
        [labelTemplate.labelTemplateItems addObject:item];
    }
}

- (OPLabelTemplateItem *)labelTemplateItemFromJSON:(NSDictionary *)rawLabelTemplateItem
{
    OPLabelTemplateItem *item = [[OPLabelTemplateItem alloc] init];
    item.attributeKey = [rawLabelTemplateItem objectForKey:@"attributeKey"];
    item.mask = [rawLabelTemplateItem objectForKey:@"mask"];
    return item;
}

- (void)setAttributes:(OPAccountOnFileAttributes *)attributes JSON:(NSArray *)rawAttributes
{
    for (NSDictionary *rawAttribute in rawAttributes) {
        OPAccountOnFileAttribute *attribute = [self attributeFromJSON:rawAttribute];
        [attributes.attributes addObject:attribute];
    }
}

- (OPAccountOnFileAttribute *)attributeFromJSON:(NSDictionary *)rawAttribute
{
    OPAccountOnFileAttribute *attribute = [[OPAccountOnFileAttribute alloc] init];
    attribute.key = [rawAttribute objectForKey:@"key"];
    attribute.value = [rawAttribute objectForKey:@"value"];
    NSString *rawStatus = [rawAttribute objectForKey:@"status"];
    if ([rawStatus isEqualToString:@"READ_ONLY"] == YES) {
        attribute.status = OPReadOnly;
    } else if ([rawStatus isEqualToString:@"CAN_WRITE"] == YES) {
        attribute.status = OPCanWrite;
    } else if ([rawStatus isEqualToString:@"MUST_WRITE"] == YES) {
        attribute.status = OPMustWrite;
    } else {
        DLog(@"Status %@ in JSON fragment %@ is invalid", rawStatus, rawAttribute);
    }
    attribute.mustWriteReason = [rawAttribute objectForKey:@"mustWriteReason"];

    return attribute;
}

@end
