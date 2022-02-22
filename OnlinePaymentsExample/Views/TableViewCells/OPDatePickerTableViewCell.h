//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"

@protocol OPDatePickerTableViewCellDelegate

-(void)datePicker:(UIDatePicker *)datePicker selectedNewDate:(NSDate *)newDate;

@end

@interface OPDatePickerTableViewCell : OPTableViewCell {
    NSDate *_date;
}

@property (nonatomic, weak) NSObject<OPDatePickerTableViewCellDelegate> *delegate;
@property (nonatomic, assign) BOOL readonly;
@property (nonatomic, strong) NSDate *date;

+(NSString *)reuseIdentifier;
+(NSUInteger)pickerHeight;

@end
