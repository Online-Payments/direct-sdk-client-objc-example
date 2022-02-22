//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"

@class OPSwitchTableViewCell;
@class OPSwitch;

@protocol OPSwitchTableViewCellDelegate

- (void)switchChanged:(OPSwitch *)aSwitch;

@end

@interface OPSwitchTableViewCell : OPTableViewCell

@property (weak, nonatomic) NSObject<OPSwitchTableViewCellDelegate> *delegate;
@property (strong, nonatomic) NSString *errorMessage;
@property (assign, nonatomic, getter=isOn) BOOL on;
@property (assign, nonatomic) BOOL readonly;

+ (NSString *)reuseIdentifier;

- (NSAttributedString *)attributedTitle;
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle;
- (void)setSwitchTarget:(id)target action:(SEL)action;

@end
