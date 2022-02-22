//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPImageTableViewCell.h"

@implementation OPImageTableViewCell

-(CGSize)cellSizeWithWidth:(CGFloat)width {
    return [self sizeTransformedFrom:self.displayImage.size toTargetWidth:width];
}

+ (NSString *)reuseIdentifier {
    return @"image-cell";
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.displayImage = nil;
}

- (CGSize)sizeTransformedFrom:(CGSize)size toTargetWidth:(CGFloat)width {
    CGFloat oldWidth = size.width;
    if (oldWidth == 0) {
        return CGSizeMake(0, 0);
    }
    CGFloat scaleFactor = width/oldWidth;
    return CGSizeMake(width, size.height * scaleFactor);
}

- (UIImage *)displayImage {
    return self.displayImageView.image;
}

- (void)setDisplayImage:(UIImage *)displayImage {
    self.displayImageView.image = displayImage;
}

- (CGSize)sizeTransformedFrom:(CGSize)size toTargetHeight:(CGFloat)height {
    CGFloat oldHeight = size.height;
    if (oldHeight == 0) {
        return CGSizeMake(0, 0);
    }
    CGFloat scaleFactor = height/oldHeight;
    return CGSizeMake(size.width * scaleFactor, height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _displayImageView = [[UIImageView alloc]init];
        [self addSubview:_displayImageView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    CGFloat newHeight = [self sizeTransformedFrom:self.displayImage.size toTargetWidth:width].height;
    
    self.displayImageView.frame = CGRectMake(leftMargin, 0, width, newHeight);
}

@end
