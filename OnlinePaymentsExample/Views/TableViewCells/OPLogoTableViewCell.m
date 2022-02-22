//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPLogoTableViewCell.h"

static CGFloat kOPLogoTableViewCellWidth = 140;

@implementation OPLogoTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

+ (NSString *)reuseIdentifier {
    return @"logo-cell";
}

- (CGSize)cellSizeWithWidth:(CGFloat)width {
    return CGSizeMake(kOPLogoTableViewCellWidth, [self sizeTransformedFrom:self.displayImageView.image.size toTargetWidth:kOPLogoTableViewCellWidth].height);
}

- (void)layoutSubviews {
    CGFloat newWidth = kOPLogoTableViewCellWidth;
    CGFloat newHeigh = [self sizeTransformedFrom:self.displayImage.size toTargetWidth:kOPLogoTableViewCellWidth].height;
    
    self.displayImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - newWidth/2, 0, newWidth, newHeigh);
}
@end
