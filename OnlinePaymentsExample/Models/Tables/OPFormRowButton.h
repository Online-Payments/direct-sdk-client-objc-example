//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPFormRow.h"
#import "OPButton.h"

@interface OPFormRowButton : OPFormRow

@property (strong, nonatomic) NSString * _Nonnull title;
@property (strong, nonatomic) id _Nonnull target;
@property (assign, nonatomic) OPButtonType buttonType;
@property (assign, nonatomic) SEL _Nonnull action;

- (instancetype _Nonnull)initWithTitle: (nonnull NSString *) title target: (nonnull id)target action: (nonnull SEL)action;

@end
