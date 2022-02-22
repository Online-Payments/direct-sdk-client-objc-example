//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPFormRowWithInfoButton.h"
#import "OPLabel.h"

@interface OPFormRowLabel : OPFormRowWithInfoButton

- (instancetype _Nonnull)initWithText:(nonnull NSString *)text;

@property (strong, nonatomic) NSString * _Nonnull text;
@property (assign, nonatomic, getter=isBold) BOOL bold;

@end
