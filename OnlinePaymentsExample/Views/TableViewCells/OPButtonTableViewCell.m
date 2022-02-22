//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPButtonTableViewCell.h"

@interface OPButtonTableViewCell ()

@property (strong, nonatomic) OPButton *button;

@end

@implementation OPButtonTableViewCell

+ (NSString *)reuseIdentifier {
    return @"button-cell";
}

- (OPButtonType)buttonType {
    return self.button.type;
}

- (void)setButtonType:(OPButtonType)type {
    self.button.type = type;
}

- (BOOL)isEnabled {
    return self.button.enabled;
}

- (void)setIsEnabled:(BOOL)enabled {
    self.button.enabled = enabled;
}

- (NSString *)title {
    return [self.button titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.button = [[OPButton alloc] init];
        [self addSubview:self.button];
        self.buttonType = OPButtonTypePrimary;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setClickTarget:(id)target action:(SEL)action {
    [self.button removeTarget: nil action: nil forControlEvents:UIControlEventAllEvents];
    [self.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = self.contentView.frame.size.height;
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    
    self.button.frame = CGRectMake(leftMargin, self.buttonType == OPButtonTypePrimary ? 12 : 6, width, height - 12);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.button removeTarget: nil action: nil forControlEvents:UIControlEventAllEvents];
}

@end
