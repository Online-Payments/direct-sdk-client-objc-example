//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPTableViewCell.h"
#import "OPIntegerTextField.h"
#import "OPFractionalTextField.h"
#import "OPFormRowField.h"

@interface OPCurrencyTableViewCell : OPTableViewCell {
    BOOL _readonly;
}

+ (NSString *)reuseIdentifier;

@property (strong, nonatomic) OPFormRowField * integerField;
@property (strong, nonatomic) OPFormRowField * fractionalField;
@property (strong, nonatomic) NSString * currencyCode;
@property (assign, nonatomic) BOOL readonly;
@property(nonatomic,weak) id<UITextFieldDelegate> delegate;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setIntegerField:(OPFormRowField *)integerField;
- (void)setFractionalField:(OPFormRowField *)fractionalField;

@end
