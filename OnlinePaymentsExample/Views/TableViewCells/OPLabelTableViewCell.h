//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPLabel.h"

@class OPFormRowLabel;

@interface OPLabelTableViewCell : OPTableViewCell

@property (assign, nonatomic, getter=isBold) BOOL bold;

+ (CGSize)cellSizeForWidth:(CGFloat)width forFormRow:(OPFormRowLabel *)label;
+ (NSString *)reuseIdentifier;

- (NSString *)label;
- (void)setLabel:(NSString *)label;

@end
