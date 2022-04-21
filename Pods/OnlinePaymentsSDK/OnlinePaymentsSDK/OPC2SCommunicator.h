//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "OPC2SCommunicatorConfiguration.h"
#import "OPPaymentContext.h"
#import "OPPublicKeyResponse.h"
#import "OPBasicPaymentProducts.h"
#import "OPPaymentProduct.h"
#import "OPAssetManager.h"
#import "OPStringFormatter.h"
#import "OPIINDetailsResponse.h"
#import "OPPaymentProductNetworks.h"

@class OPBasicPaymentProductGroups;
@class OPPaymentProductGroup;
@interface OPC2SCommunicator : NSObject

- (instancetype)initWithConfiguration:(OPC2SCommunicatorConfiguration *)configuration;
- (void)paymentProductsForContext:(OPPaymentContext *)context success:(void (^)(OPBasicPaymentProducts *paymentProducts))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductWithId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProduct *paymentProduct))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductIdByPartialCreditCardNumber:(NSString *)partialCreditCardNumber context:(OPPaymentContext *)context success:(void (^)(OPIINDetailsResponse *iinDetailsResponse))success failure:(void (^)(NSError *error))failure;
- (void)publicKey:(void (^)(OPPublicKeyResponse *publicKeyResponse))success failure:(void (^)(NSError *error))failure;
- (void)paymentProductNetworksForProductId:(NSString *)paymentProductId context:(OPPaymentContext *)context success:(void (^)(OPPaymentProductNetworks *paymentProductNetworks))success failure:(void (^)(NSError *error))failure;
- (NSString *)base64EncodedClientMetaInfo;
- (NSString *)baseURL;
- (NSString *)assetsBaseURL;
- (NSString *)clientSessionId;

@end
