//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

typedef enum  {
    OPButtonTypePrimary = 0,
    OPButtonTypeSecondary = 1,
    OPButtonTypeDestructive = 2
} OPButtonType;

@interface OPButton : UIButton

@property (assign, nonatomic) OPButtonType type;

@end
