//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

@interface OPFormRowField : NSObject

@property (strong, nonatomic)  NSString * _Nonnull text;
@property (strong, nonatomic) NSString * _Nonnull placeholder;
@property (assign, nonatomic) UIKeyboardType keyboardType;
@property (assign, nonatomic) BOOL isSecure;

- (instancetype _Nonnull)initWithText: (nonnull NSString *)text placeholder: (nonnull NSString *)placeholder keyboardType: (UIKeyboardType)keyboardType isSecure: (BOOL)isSecure;

@end
