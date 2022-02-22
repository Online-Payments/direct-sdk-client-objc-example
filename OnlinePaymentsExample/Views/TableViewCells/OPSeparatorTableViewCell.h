//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"

@class OPSeparatorView;

@interface OPSeparatorTableViewCell : OPTableViewCell

@property (nonatomic, strong) NSString *separatorText;
@property (nonatomic, strong) OPSeparatorView *view;

+ (NSString *)reuseIdentifier;

@end
