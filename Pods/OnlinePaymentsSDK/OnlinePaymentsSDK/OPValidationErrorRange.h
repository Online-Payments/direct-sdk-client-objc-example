//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPValidationError.h"

@interface OPValidationErrorRange : OPValidationError

@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;

@end
