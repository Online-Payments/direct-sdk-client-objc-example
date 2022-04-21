//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPSession.h"
#import "OPBase64.h"
#import "OPJSON.h"
#import "OPSDKConstants.h"
#import "OPPaymentItems.h"
#import <PassKit/PassKit.h>

@interface OPSession ()

@property (strong, nonatomic) OPC2SCommunicator *communicator;
@property (strong, nonatomic) OPAssetManager *assetManager;
@property (strong, nonatomic) OPEncryptor *encryptor;
@property (strong, nonatomic) OPJOSEEncryptor *JOSEEncryptor;
@property (strong, nonatomic) OPStringFormatter *stringFormatter;
@property (strong, nonatomic) OPBasicPaymentProducts *paymentProducts;
@property (strong, nonatomic) NSMutableDictionary *paymentProductMapping;
@property (strong, nonatomic) OPBase64 *base64;
@property (strong, nonatomic) OPJSON *JSON;
@property (strong, nonatomic) NSMutableDictionary *IINMapping;
@property (assign, nonatomic) BOOL iinLookupPending;

@end

@implementation OPSession

- (instancetype)initWithCommunicator:(OPC2SCommunicator *)communicator assetManager:(OPAssetManager *)assetManager encryptor:(OPEncryptor *)encryptor JOSEEncryptor:(OPJOSEEncryptor *)JOSEEncryptor stringFormatter:(OPStringFormatter *)stringFormatter
{
    self = [super init];
    if (self != nil) {
        self.base64 = [[OPBase64 alloc] init];
        self.JSON = [[OPJSON alloc] init];
        self.communicator = communicator;
        self.assetManager = assetManager;
        self.encryptor = encryptor;
        self.JOSEEncryptor = JOSEEncryptor;
        self.stringFormatter = stringFormatter;
        self.IINMapping = [[StandardUserDefaults objectForKey:kOPIINMapping] mutableCopy];
        if (self.IINMapping == nil) {
            self.IINMapping = [[NSMutableDictionary alloc] init];
        }
        self.paymentProductMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString *)baseURL {
    return [self.communicator baseURL];
}

-(NSString *)assetsBaseURL {
    return [self.communicator assetsBaseURL];
}

+ (OPSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier{
    OPUtil *util = [[OPUtil alloc] init];
    OPAssetManager *assetManager = [[OPAssetManager alloc] init];
    OPStringFormatter *stringFormatter = [[OPStringFormatter alloc] init];
    OPEncryptor *encryptor = [[OPEncryptor alloc] init];
    OPC2SCommunicatorConfiguration *configuration = [[OPC2SCommunicatorConfiguration alloc] initWithClientSessionId:clientSessionId customerId:customerId baseURL:baseURL assetBaseURL:assetBaseURL appIdentifier:appIdentifier util:util];
    OPC2SCommunicator *communicator = [[OPC2SCommunicator alloc] initWithConfiguration:configuration];
    OPJOSEEncryptor *JOSEEncryptor = [[OPJOSEEncryptor alloc] initWithEncryptor:encryptor];
    OPSession *session = [[OPSession alloc] initWithCommunicator:communicator assetManager:assetManager encryptor:encryptor JOSEEncryptor:JOSEEncryptor stringFormatter:stringFormatter];
    return session;
}

- (void)paymentProductsForContext:(OPPaymentContext *)context success:(void (^)(OPBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure
{
    [self.communicator paymentProductsForContext:context success:^(OPBasicPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProducts.paymentProducts baseURL:[self.communicator assetsBaseURL] callback:^{
            [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
            success(paymentProducts);
        }];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductNetworksForProductId:paymentProductId context:context success:^(OPPaymentProductNetworks *paymentProductNetworks) {
        success(paymentProductNetworks);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)paymentItemsForContext:(OPPaymentContext *)context groupPaymentProducts:(BOOL)groupPaymentProducts success:(void (^)(OPPaymentItems *paymentItems))success failure:(void (^)(NSError *error))failure {
    [self.communicator paymentProductsForContext:context success:^(OPBasicPaymentProducts *paymentProducts) {
        self.paymentProducts = paymentProducts;
        self.paymentProducts.stringFormatter = self.stringFormatter;
        [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
        [self.assetManager updateImagesForPaymentItemsAsynchronously:paymentProducts.paymentProducts baseURL:[self.communicator assetsBaseURL] callback:^{
            [self.assetManager initializeImagesForPaymentItems:paymentProducts.paymentProducts];
                OPPaymentItems *items = [[OPPaymentItems alloc] initWithPaymentProducts:paymentProducts groups:nil];
                success(items);
        }];

    } failure:failure];
}

- (void)paymentProductWithId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure
{
    NSString *key = [NSString stringWithFormat:@"%@-%@", paymentProductId, [context description]];
    OPPaymentProduct *paymentProduct = [self.paymentProductMapping objectForKey:key];
    if (paymentProduct != nil) {
        success(paymentProduct);
    } else {
        [self.communicator paymentProductWithId:paymentProductId context:context success:^(OPPaymentProduct *paymentProduct) {
            [self.paymentProductMapping setObject:paymentProduct forKey:key];
            [self.assetManager initializeImagesForPaymentItem:paymentProduct];
            [self.assetManager updateImagesForPaymentItemAsynchronously:paymentProduct baseURL:[self.communicator assetsBaseURL] callback:^{
                [self.assetManager initializeImagesForPaymentItem:paymentProduct];
                success(paymentProduct);
            }];
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(OPPaymentContext *)context success:(void (^)(OPIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure
{
    if (partialCreditCardNumber.length < 6) {
        OPIINDetailsResponse *response = [[OPIINDetailsResponse alloc] initWithStatus:OPNotEnoughDigits];
        success(response);
    } else if (self.iinLookupPending == YES) {
        OPIINDetailsResponse *response = [[OPIINDetailsResponse alloc] initWithStatus:OPPending];
        success(response);
    }
    else {
        self.iinLookupPending = YES;
        [self.communicator paymentProductIdByPartialCreditCardNumber:partialCreditCardNumber context:context success:^(OPIINDetailsResponse *response) {
            self.iinLookupPending = NO;
            success(response);
        } failure:^(NSError *error) {
            self.iinLookupPending = NO;
            failure(error);
        }];
    }
}

- (void)preparePaymentRequest:(OPPaymentRequest *)paymentRequest success:(void (^)(OPPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;
{
    [self.communicator publicKey:^(OPPublicKeyResponse *publicKeyResponse) {
        NSString *keyId = publicKeyResponse.keyId;
        
        NSString *encodedPublicKey = publicKeyResponse.encodedPublicKey;
        NSData *publicKeyAsData = [self.base64 decode:encodedPublicKey];
        NSData *strippedPublicKeyAsData = [self.encryptor stripPublicKey:publicKeyAsData];
        NSString *tag = @"globalcollect-sdk-public-key";
        [self.encryptor deleteRSAKeyWithTag:tag];
        [self.encryptor storePublicKey:strippedPublicKeyAsData tag:tag];
        SecKeyRef publicKey = [self.encryptor RSAKeyWithTag:tag];
        
        OPPreparedPaymentRequest *preparedRequest = [[OPPreparedPaymentRequest alloc] init];
        NSMutableString *paymentRequestJSON = [[NSMutableString alloc] init];
        NSString *clientSessionId = [NSString stringWithFormat:@"{\"clientSessionId\": \"%@\", ", [self clientSessionId]];
        [paymentRequestJSON appendString:clientSessionId];
        NSString *nonce = [NSString stringWithFormat:@"\"nonce\": \"%@\", ", [self.encryptor UUID]];
        [paymentRequestJSON appendString:nonce];
        NSString *paymentProduct = [NSString stringWithFormat:@"\"paymentProductId\": %ld, ", (long)[paymentRequest.paymentProduct.identifier integerValue]];
        [paymentRequestJSON appendString:paymentProduct];
        if (paymentRequest.accountOnFile != nil) {
            NSString *accountOnFile = [NSString stringWithFormat:@"\"accountOnFileId\": %ld, ", (long)[paymentRequest.accountOnFile.identifier integerValue]];
            [paymentRequestJSON appendString:accountOnFile];
        }
        if (paymentRequest.tokenize == YES) {
            NSString *tokenize = @"\"tokenize\": true, ";
            [paymentRequestJSON appendString:tokenize];
        }
        NSString *paymentValues = [NSString stringWithFormat:@"\"paymentValues\": %@}", [self.JSON keyValueJSONFromDictionary:paymentRequest.unmaskedFieldValues]];
        [paymentRequestJSON appendString:paymentValues];
        preparedRequest.encryptedFields = [self.JOSEEncryptor encryptToCompactSerialization:paymentRequestJSON withPublicKey:publicKey keyId:keyId];
        preparedRequest.encodedClientMetaInfo = [self.communicator base64EncodedClientMetaInfo];
        success(preparedRequest);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSString *)clientSessionId
{
    return [self.communicator clientSessionId];
}

@end
