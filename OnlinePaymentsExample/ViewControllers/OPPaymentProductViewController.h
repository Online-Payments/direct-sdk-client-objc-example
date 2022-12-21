//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPViewFactory.h"
#import "OPPaymentRequestTarget.h"
#import "OPFormRowTextField.h"
#import "OPPaymentProductInputData.h"
#import "OPFormRowSwitch.h"
#import "OPFormRowList.h"
#import "OPPickerViewTableViewCell.h"
#import "OPTextFieldTableViewCell.h"
#import "OPSwitchTableViewCell.h"
#import "OPCoBrandsSelectionTableViewCell.h"

@import OnlinePaymentsKit;

@interface OPPaymentProductViewController : UITableViewController <OPSwitchTableViewCellDelegate>

@property (weak, nonatomic) id <OPPaymentRequestTarget> paymentRequestTarget;
@property (strong, nonatomic) OPViewFactory *viewFactory;
@property (nonatomic) NSObject<OPPaymentItem> *paymentItem;
@property (strong, nonatomic) OPPaymentProduct *initialPaymentProduct;
@property (strong, nonatomic) OPAccountOnFile *accountOnFile;
@property (strong, nonatomic) OPPaymentContext *context;
@property (nonatomic) NSUInteger amount;
@property (strong, nonatomic) OPSession *session;
@property (strong, nonatomic) NSMutableSet *confirmedPaymentProducts;
@property (strong, nonatomic) NSMutableArray *formRows;
@property (strong, nonatomic) OPPaymentProductInputData *inputData;
@property (nonatomic, readonly) BOOL validation;
@property (nonatomic) BOOL switching;

- (void) addExtraRows;
- (void) registerReuseIdentifiers;
- (void)updatePickerCell:(OPPickerViewTableViewCell *)cell row: (OPFormRowList *)list;
- (void) updateTextFieldCell:(OPTextFieldTableViewCell *)cell row: (OPFormRowTextField *)row;
- (void)updateSwitchCell:(OPSwitchTableViewCell *)cell row: (OPFormRowSwitch *)row;
- (OPTextFieldTableViewCell *)cellForTextField:(OPFormRowTextField *)row tableView:(UITableView *)tableView;
- (OPTableViewCell *)formRowCellForRow:(OPFormRow *)row atIndexPath:(NSIndexPath *)indexPath;
- (void)switchToPaymentProduct:(NSString *)paymentProductId;
- (void)updateFormRows;
- (void)formatAndUpdateCharactersFromTextField:(UITextField *)texField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath;
- (void)initializeFormRows;
- (void)validateExceptFields:(NSSet *)fields;
- (void)pickerView:(OPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
