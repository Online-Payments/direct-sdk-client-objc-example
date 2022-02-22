//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPPickerViewTableViewCell.h"

@interface OPPickerViewTableViewCell ()

@property (strong, nonatomic) OPPickerView *pickerView;

@end

@implementation OPPickerViewTableViewCell

+ (NSUInteger)pickerHeight {
    return 216;
}

+ (NSString *)reuseIdentifier {
    return @"picker-view-cell";
}

- (void)setReadonly:(BOOL)readonly {
    self->_readonly = readonly;
    self->_pickerView.userInteractionEnabled = !readonly;
    self->_pickerView.alpha = readonly ? 0.6f : 1.0f;
}

- (BOOL)readonly {
    return self->_readonly;
}

- (void)setItems:(NSArray<OPValueMappingItem *> *)items {
    _items = items;
    if (items != nil) {
        NSMutableArray *names = [[NSMutableArray alloc]initWithCapacity:items.count];
        for (OPValueMappingItem *item in items) {
            [names addObject:item.displayName];
        }
        self.pickerView.content = names;
    }
}

- (NSObject<UIPickerViewDelegate> *)delegate {
    return self.pickerView.delegate;
}

- (void)setDelegate:(NSObject<UIPickerViewDelegate> *)delegate {
    self.pickerView.delegate = delegate;
}

- (NSObject<UIPickerViewDataSource> *)dataSource {
    return self.pickerView.dataSource;
}

- (void)setDataSource:(NSObject<UIPickerViewDataSource> *)dataSource {
    self.pickerView.dataSource = dataSource;
}

- (NSInteger)selectedRow {
    return [self.pickerView selectedRowInComponent:0];
}

- (void)setSelectedRow:(NSInteger)selectedRow {
    [self.pickerView selectRow:selectedRow inComponent:0 animated:false];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.pickerView = [OPPickerView new];
    
    [self addSubview:self.pickerView];
    
    self.clipsToBounds = YES;
    
    return self;
}

- (CGFloat)pickerLeftMarginForFitSize:(CGSize)fitsize {
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        if (self.contentView.frame.size.width > CGRectGetMidX(self.frame) - fitsize.width/2 + fitsize.width)
        {
            return CGRectGetMidX(self.frame) - fitsize.width/2;
        }
        else {
            return 16;
        }
    }
    else {
        if(self.contentView.frame.size.width > CGRectGetMidX(self.frame) - fitsize.width/2 + fitsize.width + 16 + 22 + 16) {
            return CGRectGetMidX(self.frame) - fitsize.width/2;
        }
        else {
            return 16;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.pickerView != nil) {
        CGFloat width = self.contentView.frame.size.width;
        CGFloat height =  [OPPickerViewTableViewCell pickerHeight];
        CGRect frame = CGRectMake(10, 0, width - 20,height);
        frame.size = [self.pickerView sizeThatFits:frame.size];
        frame.origin.x = width/2 - frame.size.width/2;
        self.pickerView.frame = frame;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.items = [[NSArray alloc] init];
    self.delegate = nil;
    self.dataSource = nil;
}

@end
