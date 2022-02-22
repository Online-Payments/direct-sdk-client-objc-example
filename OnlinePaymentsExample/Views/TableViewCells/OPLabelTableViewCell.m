//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPLabelTableViewCell.h"
#import "OPFormRowLabel.h"

@interface OPLabelTableViewCell ()

@property (strong, nonatomic) OPLabel *labelView;

@end

@implementation OPLabelTableViewCell

@synthesize bold = _bold;

+ (UIFont *)labelFontForBold:(BOOL)boldness {
    UIFont *font;
    if (boldness) {
        font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    }
    else {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    return font;
}

+ (CGSize)labelSizeForWidth: (CGFloat)width forText:(NSString *)text bold: (BOOL)bold {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize constrainRect = CGSizeMake(width, CGFLOAT_MAX);
    UILabel *dummyLabel = [[UILabel alloc]init];
    dummyLabel.numberOfLines = 0;
    dummyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dummyLabel.text = text;
    CGSize size = [dummyLabel sizeThatFits:constrainRect];
    
    return size;
}

+ (CGSize)cellSizeForWidth:(CGFloat)width forFormRow:(OPFormRowLabel *)label {
    CGSize labelSize = [self labelSizeForWidth:width forText:label.text bold:label.bold];
    labelSize.height += 8;
    
    return labelSize;
}

- (CGSize)labelSizeForWidth: (CGFloat)width {
    return [[self class] labelSizeForWidth:width forText:self.label bold:self.bold];
}

+ (NSString *)reuseIdentifier {
    return @"label-cell";
}

- (NSString *)label {
    return self.labelView.text;
}

- (void)setLabel:(NSString *)label {
    self.labelView.text = label;
    self.labelView.numberOfLines = 0;
}

- (BOOL) isBold {
    return _bold;
}

- (void) setBold:(BOOL)bold {
    _bold = bold;
    UIFont *font = [[self class] labelFontForBold:bold];
    self.labelView.font = font;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelView = [[OPLabel alloc]init];
        [self addSubview:self.labelView];
        self.clipsToBounds = YES;
        self.labelView.numberOfLines = 0;
        self.labelView.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [self accessoryAndMarginCompatibleWidth];
    CGFloat leftMargin = [self accessoryCompatibleLeftMargin];
    self.labelView.frame = CGRectMake(leftMargin, 4, width, [self labelSizeForWidth: width].height);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.label = nil;
}
@end
