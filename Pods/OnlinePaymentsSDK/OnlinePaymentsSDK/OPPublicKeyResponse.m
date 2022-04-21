//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPPublicKeyResponse.h"

@implementation OPPublicKeyResponse

- (instancetype)initWithKeyId:(NSString *)keyId encodedPublicKey:(NSString *)encodedPublicKey
{
    self = [super init];
    if (self != nil) {
        _keyId = keyId;
        _encodedPublicKey = encodedPublicKey;
    }
    return self;
}

@end
