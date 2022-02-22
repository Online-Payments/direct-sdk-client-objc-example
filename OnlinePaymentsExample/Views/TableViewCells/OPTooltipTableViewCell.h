//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPFormRowTooltip.h"

@interface OPTooltipTableViewCell : OPTableViewCell

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) UIImage *tooltipImage;

+ (CGSize)cellSizeForWidth:(CGFloat)width forFormRow:(OPFormRowTooltip *)label;
+ (NSString *)reuseIdentifier;

@end
