//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

@class OPDisplayElement;

@interface OPValueMappingItem : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSArray<OPDisplayElement *>* displayElements;
@property (strong, nonatomic) NSString *value;

@end
