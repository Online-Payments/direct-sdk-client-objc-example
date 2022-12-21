//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPPickerView.h"
@import OnlinePaymentsKit;

@interface OPPickerViewTableViewCell : OPTableViewCell {
    BOOL _readonly;
}

@property (strong, nonatomic) NSArray<OPValueMappingItem *> *items;
@property (strong, nonatomic) NSObject<UIPickerViewDelegate> *delegate;
@property (strong, nonatomic) NSObject<UIPickerViewDataSource> *dataSource;
@property (assign, nonatomic) NSInteger selectedRow;
@property (assign, nonatomic) BOOL readonly;

+ (NSUInteger)pickerHeight;
+ (NSString *)reuseIdentifier;

@end
