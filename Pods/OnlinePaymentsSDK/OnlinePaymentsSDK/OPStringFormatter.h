//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface OPStringFormatter : NSObject

- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask cursorPosition:(NSInteger *)cursorPosition;
- (NSString *)formatString:(NSString *)string withMask:(NSString *)mask;
- (NSString *)unformatString:(NSString *)string withMask:(NSString *)mask;
- (NSString *)relaxMask:(NSString *)mask;

@end
