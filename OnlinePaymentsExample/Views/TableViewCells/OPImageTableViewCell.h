//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"

@interface OPImageTableViewCell : OPTableViewCell

@property (nonatomic, retain) UIImageView *displayImageView;
@property (nonatomic, retain) UIImage *displayImage;

+(NSString *)reuseIdentifier;

-(CGSize)sizeTransformedFrom:(CGSize)size toTargetWidth:(CGFloat)width;
-(CGSize)sizeTransformedFrom:(CGSize)size toTargetHeight:(CGFloat)height;
-(CGSize)cellSizeWithWidth:(CGFloat)width;

@end
