//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <XCTest/XCTest.h>
#import "OPBasicPaymentProducts.h"
#import "OPBasicPaymentProductsConverter.h"
#import "OPPaymentProductsTableSection.h"
#import "OPPaymentProductsTableRow.h"
#import "OPTableSectionConverter.h"
#import "OPAccountOnFile.h"
#import "OPPaymentItems.h"

@interface OPTableSectionConverterTestCase : XCTestCase

@property (strong, nonatomic) OPBasicPaymentProductsConverter *paymentProductsConverter;
@property (strong, nonatomic) OPStringFormatter *stringFormatter;

@end

@implementation OPTableSectionConverterTestCase

- (void)setUp
{
    [super setUp];
    self.paymentProductsConverter = [[OPBasicPaymentProductsConverter alloc] init];
    self.stringFormatter = [[OPStringFormatter alloc] init];
}

- (void)testPaymentProductsTableSectionFromAccountsOnFile
{
    NSString *paymentProductsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProducts" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductsData = [fileManager contentsAtPath:paymentProductsPath];
    NSDictionary *paymentProductsJSON = [NSJSONSerialization JSONObjectWithData:paymentProductsData options:0 error:NULL];
    OPBasicPaymentProducts *paymentProducts = [self.paymentProductsConverter paymentProductsFromJSON:[paymentProductsJSON objectForKey:@"paymentProducts"]];
    NSArray *accountsOnFile = [paymentProducts accountsOnFile];
    for (OPAccountOnFile *accountOnFile in accountsOnFile) {
        accountOnFile.stringFormatter = self.stringFormatter;
    }

    OPPaymentItems *items = [[OPPaymentItems alloc] init];
    items.paymentItems = paymentProducts.paymentProducts;
    OPPaymentProductsTableSection *tableSection = [OPTableSectionConverter paymentProductsTableSectionFromAccountsOnFile:accountsOnFile paymentItems:items];
    OPPaymentProductsTableRow *row = tableSection.rows[0];
    XCTAssertTrue([row.name isEqualToString:@"**** **** **** 7988 Rob"] == YES, @"Unexpected title of table section");
}

@end
