//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPC2SCommunicatorConfiguration.h"
#import "OPSDKConstants.h"

@interface OPC2SCommunicatorConfiguration ()

@property (strong, nonatomic) OPUtil *util;

@end

@implementation OPC2SCommunicatorConfiguration

- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier util:(OPUtil *)util {
    self = [super init];
    if (self != nil) {
        self.clientSessionId = clientSessionId;
        self.customerId = customerId;
        self.baseURL = baseURL;
        self.assetsBaseURL = assetBaseURL;
        self.util = util;
        self.appIdentifier = appIdentifier;
    }
    return self;
}
- (instancetype)initWithClientSessionId:(NSString *)clientSessionId customerId:(NSString *)customerId baseURL:(NSString *)baseURL assetBaseURL:(NSString *)assetBaseURL appIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress util:(OPUtil *)util {
    self = [super init];
    if (self != nil) {
        self.clientSessionId = clientSessionId;
        self.customerId = customerId;
        self.baseURL = baseURL;
        self.assetsBaseURL = assetBaseURL;
        self.util = util;
        self.appIdentifier = appIdentifier;
        self.ipAddress = ipAddress;
    }
    return self;
}

- (NSString *)fixURL:(NSString *)url
{
    NSMutableArray<NSString *> *components;
    if (@available(iOS 7.0, *)) {
        NSURLComponents *finalComponents = [NSURLComponents componentsWithString:url];
        components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    else {
        components = [[[NSURL URLWithString:url].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    
    
    NSArray<NSString *> *versionComponents = [kOPAPIVersion componentsSeparatedByString:@"/"];
    NSString *exceptionReason = [NSString stringWithFormat: @"This version of the Online Payments SDK is only compatible with %@ , you supplied: '%@'",
                                 [versionComponents componentsJoinedByString: @"/"],
                                 [components componentsJoinedByString: @"/"]];
    NSException *invalidURLException = [NSException exceptionWithName:@"OPInvalidURLException"
                                                               reason:exceptionReason
                                                             userInfo:nil];
    NSURL *nsurl = [NSURL URLWithString:url];
    switch (components.count) {
        case 0: {
            components = versionComponents.mutableCopy;
            break;
        }
        case 1: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                @throw invalidURLException;
            }
            [components addObject:versionComponents[1]];
            break;
        }
        case 2: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                @throw invalidURLException;
            }
            if (![components[1] isEqualToString:versionComponents[1]]) {
                @throw invalidURLException;
            }
            break;
        }
        default: {
            @throw invalidURLException;
            break;
        }
    }
    if (@available(iOS 7.0, *)) {
        NSURLComponents *finalComponents = [NSURLComponents componentsWithString:url];
        finalComponents.path = [@"/" stringByAppendingString:[components componentsJoinedByString:@"/"]];
        return finalComponents.URL.absoluteString;
    }
    while ([nsurl.path stringByReplacingOccurrencesOfString:@"/" withString:@""].length) {
        nsurl = [nsurl URLByDeletingLastPathComponent];
    }
    for (NSString *component in components) {
        nsurl = [nsurl URLByAppendingPathComponent:component];
    }
    return nsurl.absoluteString;
}

- (void)setBaseURL:(NSString *)baseURL {
    self->_baseURL = [self fixURL:baseURL];
}

- (NSString *)baseURL
{
    return self->_baseURL;
}

- (NSString *)assetsBaseURL
{
    return self->_assetsBaseURL;
}

- (NSString *)base64EncodedClientMetaInfo
{
    return [self.util base64EncodedClientMetaInfoWithAppIdentifier:self.appIdentifier ipAddress:self.ipAddress];
}


@end
