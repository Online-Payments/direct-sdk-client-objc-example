//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface OPAFNetworkingWrapper : NSObject

- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure DEPRECATED_ATTRIBUTE __deprecated_msg("use OPNetworkingWrapper#getResponseForUrl:headers:additionalAcceptableStatusCodes:success:failure instead");
- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure DEPRECATED_ATTRIBUTE __deprecated_msg("use OPNetworkingWrapper#postResponseForUrl:headers:additionalAcceptableStatusCodes:success:failure instead");;

@end
