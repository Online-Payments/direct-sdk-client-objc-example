//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPSeparatorTableViewCell.h"
#import "OPSeparatorView.h"

@implementation OPSeparatorTableViewCell

+ (NSString *)reuseIdentifier {
    return @"separator-cell";
}

- (void)setSeparatorText:(NSString *)text {
    self.view.separatorString = text;
}

- (NSString *)separatorText {
    return self.view.separatorString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.view = [[OPSeparatorView alloc] init];
        [self addSubview:self.view];
        [self.view setOpaque:NO];
        self.clipsToBounds = YES;
        [self.view setContentMode:UIViewContentModeCenter];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    CGFloat newHeight = self.contentView.frame.size.height;
    self.view.frame = CGRectMake(leftMargin, 0, width, newHeight);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.separatorText = nil;
}

@end
