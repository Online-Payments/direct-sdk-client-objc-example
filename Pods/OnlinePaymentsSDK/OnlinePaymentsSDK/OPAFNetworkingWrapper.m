//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "OPAFNetworkingWrapper.h"
#import "OPNetworkingWrapper.h"

@interface OPAFNetworkingWrapper ()

    @property (strong, nonatomic) OPNetworkingWrapper *_OPNetworkingWrapper;

@end

@implementation OPAFNetworkingWrapper

- (instancetype)init {

    self._OPNetworkingWrapper = [[OPNetworkingWrapper alloc] init];

    return self;
}


- (void)getResponseForURL:(NSString *)URL headers:(NSDictionary *)headers additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"OPAFNetworkingWrapper is deprecated! Please use OPNetworkingWrapper instead.");
    [self._OPNetworkingWrapper getResponseForURL:URL headers:headers additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:success failure:failure];
}


- (void)postResponseForURL:(NSString *)URL headers:(NSDictionary *)headers withParameters:(NSDictionary *)parameters additionalAcceptableStatusCodes:(NSIndexSet *)additionalAcceptableStatusCodes success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSLog(@"OPAFNetworkingWrapper is deprecated! Please use OPNetworkingWrapper instead.");
    [self._OPNetworkingWrapper postResponseForURL:URL headers:headers withParameters:parameters additionalAcceptableStatusCodes:additionalAcceptableStatusCodes success:success failure:failure];
}

@end
