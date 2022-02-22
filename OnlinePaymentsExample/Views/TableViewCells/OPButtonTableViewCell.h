//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPButton.h"

@interface OPButtonTableViewCell : OPTableViewCell

+ (NSString *)reuseIdentifier;

- (BOOL)isEnabled;
- (void)setIsEnabled:(BOOL)enabled;

- (OPButtonType)buttonType;
- (void)setButtonType:(OPButtonType)type;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (void)setClickTarget:(id)target action:(SEL)action;

@end
