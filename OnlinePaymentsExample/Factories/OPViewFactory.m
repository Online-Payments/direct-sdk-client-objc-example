//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPViewFactory.h"
#import "OPIntegerTextField.h"
#import "OPFractionalTextField.h"
#import "OPSummaryTableHeaderView.h"

@implementation OPViewFactory

- (OPButton *)buttonWithType:(OPButtonType)type
{
    OPButton *button = [OPButton new];
    button.type = type;
    
    return button;
}

- (OPSwitch *)switchWithType:(OPViewType)type
{
    OPSwitch *switchControl;
    switch (type) {
        case OPSwitchType:
            switchControl = [[OPSwitch alloc] init];
            break;
        default:
            [NSException raise:@"Invalid switch type" format:@"Switch type %u is invalid", type];
            break;
    }
    return switchControl;
}

- (OPTextField *)textFieldWithType:(OPViewType)type
{
    OPTextField *textField;
    switch (type) {
        case OPTextFieldType:
            textField = [[OPTextField alloc] init];
            break;
        case OPIntegerTextFieldType:
            textField = [[OPIntegerTextField alloc] init];
            break;
        case OPFractionalTextFieldType:
            textField = [[OPFractionalTextField alloc] init];
            break;
        default:
            [NSException raise:@"Invalid text field type" format:@"Text field type %u is invalid", type];
            break;
    }
    return textField;
}

- (OPPickerView *)pickerViewWithType:(OPViewType)type
{
    OPPickerView *pickerView;
    switch (type) {
        case OPPickerViewType:
            pickerView = [[OPPickerView alloc] init];
            break;
        default:
            [NSException raise:@"Invalid picker view type" format:@"Picker view type %u is invalid", type];
            break;
    }
    return pickerView;
}

- (OPLabel *)labelWithType:(OPViewType)type
{
    OPLabel *label;
    switch (type) {
        case OPLabelType:
            label = [[OPLabel alloc] init];
            break;
        default:
            [NSException raise:@"Invalid label type" format:@"Label type %u is invalid", type];
            break;
    }
    return label;
}

- (UIView *)tableHeaderViewWithType:(OPViewType)type frame:(CGRect)frame
{
    UIView *view;
    switch (type) {
        case OPSummaryTableHeaderViewType:
            view = [[OPSummaryTableHeaderView alloc] initWithFrame:frame];
            break;
        default:
            [NSException raise:@"Invalid table header view type" format:@"Table header view type %u is invalid", type];
            break;
    }
    return view;
}

@end
