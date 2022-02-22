//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OPPaymentProductInputData.h"
#import "OPPaymentProductConverter.h"
#import "OPPaymentRequest.h"

@interface OPPaymentProductInputDataTestCase : XCTestCase

@property (nonatomic, strong) OPPaymentProductInputData *inputData;
@property (nonatomic, strong) OPPaymentProductConverter *converter;

@end

@implementation OPPaymentProductInputDataTestCase

- (void)setUp {
    [super setUp];

    self.inputData = [[OPPaymentProductInputData alloc] init];
    self.converter = [[OPPaymentProductConverter alloc] init];
    NSString *paymentProductPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"paymentProduct" ofType:@"json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *paymentProductData = [fileManager contentsAtPath:paymentProductPath];
    NSDictionary *paymentProductJSON = [NSJSONSerialization JSONObjectWithData:paymentProductData options:0 error:NULL];
    OPPaymentProduct *paymentProduct = [self.converter paymentProductFromJSON:paymentProductJSON];
    self.inputData.paymentItem = paymentProduct;
    self.inputData.accountOnFile = paymentProduct.accountsOnFile.accountsOnFile[0];
}

- (void)testSetValue
{
    [self.inputData setValue:@"12345678" forField:@"cardNumber"];
    NSString *maskedValue = [self.inputData maskedValueForField:@"cardNumber"];
    NSString *expectedOutput = @"1234 5678 ";
    XCTAssertTrue([maskedValue isEqualToString:expectedOutput] == YES, @"Value not set correctly in payment request");
}

- (void)testValidate
{
    [self.inputData setValue:@"1" forField:@"cvv"];
    [self.inputData validate];
    XCTAssertTrue(self.inputData.errors.count == 2, @"Unexpected number of errors while validating payment request");
}

- (void)testFieldIsPartOfAccountOnFileYes
{
    XCTAssertTrue([self.inputData fieldIsPartOfAccountOnFile:@"cardNumber"] == YES, @"Card number should be part of account on file");
}

- (void)testFieldIsPartOfAccountOnFileNo
{
    XCTAssertTrue([self.inputData fieldIsPartOfAccountOnFile:@"cvv"] == NO, @"CVV should not be part of account on file");
}

- (void)testMaskedValueForField
{
    [self.inputData setValue:@"0820" forField:@"expiryDate"];
    NSString *maskedValue = [self.inputData maskedValueForField:@"expiryDate"];
    XCTAssertTrue([maskedValue isEqualToString:@"08/20"] == YES, @"Masked expiry date is incorrect");
}

- (void)testMaskedValueForFieldWithCursorPosition
{
    [self.inputData setValue:@"0820" forField:@"expiryDate"];
    NSInteger cursorPosition = 4;
    NSString *maskedValue = [self.inputData maskedValueForField:@"expiryDate" cursorPosition:&cursorPosition];
    XCTAssertTrue([maskedValue isEqualToString:@"08/20"] == YES, @"Masked expiry date is incorrect");
    XCTAssertTrue(cursorPosition == 5, @"Cursor position after applying mask is incorrect");
}

- (void)testUnmaskedValueForField
{
    [self.inputData setValue:@"0820" forField:@"expiryDate"];
    NSString *value = [self.inputData unmaskedValueForField:@"expiryDate"];
    XCTAssertTrue([value isEqualToString:@"0820"] == YES, @"Unmasked expiry date is incorrect");
}

@end
