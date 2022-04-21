//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

#import "OPUtil.h"
#import "OPBase64.h"
#import "OPMacros.h"

@interface OPUtil ()

@property (strong, nonatomic) NSDictionary *metaInfo;
@property (strong, nonatomic) OPBase64 *base64;
@property (strong, nonatomic) NSArray *c2sBaseURLMapping;
@property (strong, nonatomic) NSArray *assetsBaseURLMapping;

@end

@implementation OPUtil

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSString *platformIdentifier = [self platformIdentifier];
        NSString *screenSize = [self screenSize];
        NSString *deviceType = [self deviceType];
        self.metaInfo = @{
            @"platformIdentifier": platformIdentifier,
            @"sdkIdentifier": @"objcClientSDK/v2.0.0",
            @"sdkCreator": @"OnlinePayments",
            @"screenSize": screenSize,
            @"deviceBrand": @"Apple",
            @"deviceType": deviceType};
        self.base64 = [[OPBase64 alloc] init];
    }
    return self;
}

- (NSString *)platformIdentifier
{
    NSString *OSName = [[UIDevice currentDevice] systemName];
    NSString *OSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *platformIdentifier = [NSString stringWithFormat:@"%@/%@", OSName, OSVersion];
    return platformIdentifier;
}

- (NSString *)screenSize
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    NSString *screenSizeAsString = [NSString stringWithFormat:@"%dx%d", (int)screenSize.width, (int)screenSize.height];
    return screenSizeAsString;
}

// The following method is based on code published by Scott Kantner on TechRepublic
// http://www.techrepublic.com/blog/software-engineer/better-code-determine-device-types-and-ios-versions/

- (NSString *)deviceType {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

- (NSString *)base64EncodedClientMetaInfo
{
    return [self base64EncodedClientMetaInfoWithAppIdentifier:nil];
}

- (NSString *)base64EncodedClientMetaInfoWithAddedData:(NSDictionary *)addedData
{
    return [self base64EncodedClientMetaInfoWithAppIdentifier:nil ipAddress:nil addedData:addedData];
}

- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier {
    return [self base64EncodedClientMetaInfoWithAppIdentifier:appIdentifier ipAddress:nil addedData:nil];
}

- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress {
    return [self base64EncodedClientMetaInfoWithAppIdentifier:appIdentifier ipAddress:ipAddress addedData:nil];
}

- (NSString *)base64EncodedClientMetaInfoWithAppIdentifier:(NSString *)appIdentifier ipAddress:(NSString *)ipAddress addedData:(NSDictionary *)addedData {
    NSMutableDictionary *metaInfo = [self.metaInfo mutableCopy];
    if (addedData != nil) {
        [metaInfo addEntriesFromDictionary:addedData];
    }
    
    if (appIdentifier && appIdentifier.length > 0) {
        metaInfo[@"appIdentifier"] = appIdentifier;
    }
    else {
        metaInfo[@"appIdentifier"] = @"UNKNOWN";
    }
    
    if (ipAddress && ipAddress.length > 0) {
        metaInfo[@"ipAddress"] = ipAddress;
    }
    
    NSString *encodedMetaInfo = [self base64EncodedStringFromDictionary:metaInfo];
    return encodedMetaInfo;
}

- (NSString *)base64EncodedStringFromDictionary:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error != nil) {
        DLog(@"Unable to serialize dictionary");
        return @"";
    }
    NSString *encodedString = [self.base64 encode:JSONData];
    return encodedString;
}

@end
