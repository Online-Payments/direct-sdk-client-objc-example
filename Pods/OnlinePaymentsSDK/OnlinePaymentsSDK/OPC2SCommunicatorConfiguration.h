//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "OPUtil.h"

@interface OPC2SCommunicatorConfiguration : NSObject {
    NSString *_baseURL;
}

@property (strong, nonatomic) NSString *clientSessionId;
@property (strong, nonatomic) NSString *customerId;

@property (nonatomic, strong) NSString *appIdentifier;
@property (nonatomic, strong) NSString *ipAddress;

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *assetsBaseURL;

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier util:(OPUtil *)util;
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(OPUtil *)util;
- (NSString *)base64EncodedClientMetaInfo;

@end
