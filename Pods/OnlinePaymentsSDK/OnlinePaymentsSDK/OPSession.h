//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "OPPaymentRequest.h"
#import "OPBasicPaymentProducts.h"
#import "OPC2SCommunicator.h"
#import "OPIINDetailsResponse.h"
#import "OPPreparedPaymentRequest.h"
#import "OPPaymentContext.h"
#import "OPAssetManager.h"
#import "OPJOSEEncryptor.h"

@interface OPSession : NSObject
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *assetsBaseURL;

- (instancetype)initWithCommunicator:(OPC2SCommunicator *)communicator assetManager:(OPAssetManager *)assetManager encryptor:(OPEncryptor *)encryptor JOSEEncryptor:(OPJOSEEncryptor *)JOSEEncryptor stringFormatter:(OPStringFormatter *)stringFormatter;
+ (OPSession *)sessionWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier;

- (void)paymentProductsForContext:(OPPaymentContext *)context success:(void (^)(OPBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentItemsForContext:(OPPaymentContext *)context groupPaymentProducts:(BOOL)groupPaymentProducts success:(void (^)(OPPaymentItems *paymentItems))success failure:(void (^)(NSError *error))failure;

- (void)paymentProductWithId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;

- (void)IINDetailsForPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(OPPaymentContext *)context success:(void (^)(OPIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure;
- (void)preparePaymentRequest:(OPPaymentRequest *)paymentRequest success:(void (^)(OPPreparedPaymentRequest *preparedPaymentRequest))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure;

@end
