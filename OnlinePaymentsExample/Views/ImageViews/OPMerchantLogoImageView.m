//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPMerchantLogoImageView.h"

@implementation OPMerchantLogoImageView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 20, 20)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *logo = [UIImage imageNamed:@"MerchantLogo"];
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.image = logo;
    }
    return self;
}

@end
