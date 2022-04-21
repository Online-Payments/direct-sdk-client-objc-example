//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface OPPreparedPaymentRequest : NSObject

@property (strong, nonatomic) NSString *encryptedFields;
@property (strong, nonatomic) NSString *encodedClientMetaInfo;

@end
