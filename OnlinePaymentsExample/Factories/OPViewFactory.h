//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPViewType.h"
#import "OPTableViewCell.h"
#import "OPSwitch.h"
#import "OPTextField.h"
#import "OPPickerView.h"
#import "OPLabel.h"
#import "OPButton.h"

@interface OPViewFactory : NSObject

- (OPButton *)buttonWithType:(OPButtonType)type;
- (OPSwitch *)switchWithType:(OPViewType)type;
- (OPTextField *)textFieldWithType:(OPViewType)type;
- (OPPickerView *)pickerViewWithType:(OPViewType)type;
- (OPLabel *)labelWithType:(OPViewType)type;
- (UIView *)tableHeaderViewWithType:(OPViewType)type frame:(CGRect)frame;

@end

