//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPDetailedPickerViewCell.h"
#import <OnlinePaymentsSDK/OPDisplayElement.h>
#import <OnlinePaymentsSDK/OPSDKConstants.h>

@interface OPDetailedPickerViewCell ()

@property (nonatomic, strong) UITextView *labelView;
@property (nonatomic, weak) NSObject<UIPickerViewDelegate> *transitiveDelegate;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, assign) BOOL labelNeedsUpdate;

@end

@implementation OPDetailedPickerViewCell

- (NSObject<UIPickerViewDelegate> *)delegate {
    return self.transitiveDelegate;
}

- (void)setDelegate:(NSObject<UIPickerViewDelegate> *)delegate {
    self.transitiveDelegate = delegate;
}

- (NSString *)errorMessage {
    return self.errorLabel.text;
}

- (void)setErrorMessage:(NSString *)errorMessage {
    self.errorLabel.text = errorMessage;
    [self setNeedsLayout];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.delegate) {
        return [self.delegate pickerView:pickerView attributedTitleForRow:row forComponent:component];
    }
    return nil;
}

- (void)setSelectedRow:(NSInteger)selectedRow {
    [super setSelectedRow:selectedRow];
    
    // We need to update the label later, when the width is known
    if (!self.labelNeedsUpdate) {
        [self updateLabelWithRow:selectedRow];

    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [super setDelegate:self];
        self.labelView = [[UITextView alloc]init];
        self.labelView.editable = NO;
        self.labelView.scrollEnabled = NO;
        self.labelView.dataDetectorTypes = UIDataDetectorTypeLink;
        self.clipsToBounds = YES;
        
        [self addSubview:self.labelView];
        
        self.errorLabel = [[UILabel alloc]init];
        self.errorLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.errorLabel.numberOfLines = 0;
        self.errorLabel.textColor = [UIColor redColor];
        
        [self addSubview:self.errorLabel];
        
        // We need to populate the textView, but we need the width for it,
        // and the width is only known after -layoutSubViews is called
        self.labelNeedsUpdate = YES;
        [self setNeedsLayout];

    }
    return self;
}

- (NSAttributedString *)labelForRow:(NSInteger)row {
    if (self.items[row].displayElements.count < 2) {
        return [[NSAttributedString alloc]init];
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.tabStops = @[[[NSTextTab alloc]initWithTextAlignment:NSTextAlignmentRight location:[self accessoryAndMarginCompatibleWidth] - 10  options:@{}]];
    NSMutableAttributedString *combiString = [[NSMutableAttributedString alloc]init];
    for (OPDisplayElement *el in self.items[row].displayElements) {
        NSAttributedString *attributedEl = [self attributedStringFromDisplayElement:el];
        if (combiString.length > 0) {
            [combiString appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
        }
        [combiString appendAttributedString:attributedEl];
    }
    [combiString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, (combiString.length))];
    return combiString;
}

- (void)updateLabelWithRow:(NSInteger)row {
    self.labelNeedsUpdate = NO;
    NSAttributedString *combiString = [self labelForRow:row];
    self.labelView.attributedText = combiString;
    [self.labelView sizeToFit];
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedStringFromDisplayElement:(OPDisplayElement *)element {
    NSMutableAttributedString *returnValue = [[NSMutableAttributedString alloc]init];
    NSAttributedString *left;
    NSAttributedString *right;
    NSString *elementKey = [NSString stringWithFormat:@"gc.general.paymentProductFields.%@.fields.%@.label",self.fieldIdentifier , element.identifier];
    NSString *elementId = NSLocalizedStringWithDefaultValue(elementKey, kOPSDKLocalizable, [NSBundle bundleWithPath:kOPSDKBundlePath], element.identifier, @"");
    switch (element.type) {
        case OPDisplayElementTypeCurrency:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:[self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:[element.value doubleValue]/100]]];
            break;
        case OPDisplayElementTypePercentage:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:[self.percentFormatter stringFromNumber:[NSNumber numberWithDouble:[element.value doubleValue]/100]]];
            break;
        case OPDisplayElementTypeString:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:element.value];
            break;
        case OPDisplayElementTypeURI:
            left = [[NSAttributedString alloc]initWithString:elementId attributes:@{NSLinkAttributeName: element.value}];
            right = nil;
            break;
        case OPDisplayElementTypeInteger:
            left = [[NSAttributedString alloc]initWithString:elementId];
            right = [[NSAttributedString alloc]initWithString:element.value];
            break;
    }
    [returnValue appendAttributedString:left];
    if (right != nil) {
        [returnValue appendAttributedString:[[NSAttributedString alloc]initWithString:@"\t"]];
        [returnValue appendAttributedString:right];
    }
    return returnValue;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    self.errorLabel.frame = CGRectMake(leftMargin, [OPDetailedPickerViewCell pickerHeight] + 5, width, 500);
    self.errorLabel.preferredMaxLayoutWidth = width - 20;
    [self.errorLabel sizeToFit];

    CGRect labelFrame = CGRectMake(leftMargin, [OPDetailedPickerViewCell pickerHeight] + 20, width, [OPDetailedPickerViewCell pickerHeight] );
    labelFrame.size.height = [self.labelView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
    self.labelView.frame = labelFrame;
    
    if (self.labelNeedsUpdate) {
        [self updateLabelWithRow:self.selectedRow];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self updateLabelWithRow: row];
    if (self.transitiveDelegate) {
        [self.transitiveDelegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
}

@end
