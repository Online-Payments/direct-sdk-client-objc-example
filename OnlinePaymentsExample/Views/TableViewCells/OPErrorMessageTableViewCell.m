//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPErrorMessageTableViewCell.h"

@implementation OPErrorMessageTableViewCell

+ (NSString *)reuseIdentifier {
    return @"error-cell";
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:12.0f];
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor redColor];
        self.clipsToBounds = YES;
    }
    return self;
}

@end
