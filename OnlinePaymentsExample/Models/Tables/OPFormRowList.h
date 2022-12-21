//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPFormRow.h"
#import "OPPickerView.h"
@import OnlinePaymentsKit;

@interface OPFormRowList : OPFormRow

- (instancetype _Nonnull)initWithPaymentProductField: (nonnull OPPaymentProductField *)paymentProductField;

@property (strong, nonatomic) NSMutableArray<OPValueMappingItem *> * _Nonnull items;
@property (nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) OPPaymentProductField * _Nonnull paymentProductField;

@end
