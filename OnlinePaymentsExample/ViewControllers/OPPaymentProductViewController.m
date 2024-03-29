//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPAppConstants.h"
#import "OPPaymentProductViewController.h"
#import "OPFormRowsConverter.h"
#import "OPFormRow.h"
#import "OPFormRowDate.h"
#import "OPFormRowTextField.h"
#import "OPFormRowCurrency.h"
#import "OPFormRowSwitch.h"
#import "OPFormRowList.h"
#import "OPFormRowButton.h"
#import "OPFormRowLabel.h"
#import "OPFormRowErrorMessage.h"
#import "OPFormRowTooltip.h"
#import "OPTableViewCell.h"
#import "OPDatePickerTableViewCell.h"
#import "OPSummaryTableHeaderView.h"
#import "OPMerchantLogoImageView.h"
#import "OPFormRowCoBrandsSelection.h"
#import "OPFormRowCoBrandsExplanation.h"
#import "OPPaymentProductInputData.h"
#import "OPFormRowReadonlyReview.h"
#import "OPReadonlyReviewTableViewCell.h"
#import "OPPaymentProductsTableRow.h"
#import "OPCurrencyTableViewCell.h"
#import "OPLabelTableViewCell.h"
#import "OPButtonTableViewCell.h"
#import "OPCurrencyTableViewCell.h"
#import "OPErrorMessageTableViewCell.h"
#import "OPTooltipTableViewCell.h"
#import "OPPaymentProductTableViewCell.h"
#import "OPCOBrandsExplanationTableViewCell.h"

@import OnlinePaymentsKit;

@interface OPPaymentProductViewController () <UITextFieldDelegate, OPDatePickerTableViewCellDelegate, OPSwitchTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *tooltipRows;
@property (nonatomic) BOOL rememberPaymentDetails;
@property (strong, nonatomic) OPSummaryTableHeaderView *header;
@property (strong, nonatomic) UITextPosition *cursorPositionInCreditCardNumberTextField;
@property (nonatomic) BOOL validation;
@property (nonatomic, strong) OPIINDetailsResponse *iinDetailsResponse;
@property (nonatomic, assign) BOOL coBrandsCollapsed;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation OPPaymentProductViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        self.sdkBundle = [NSBundle bundleWithPath:OPSDKConstants.kOPSDKBundlePath];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setDelaysContentTouches:)] == YES) {
        self.tableView.delaysContentTouches = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [[OPMerchantLogoImageView alloc] init];
    
    self.rememberPaymentDetails = NO;
    
    [self initializeHeader];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)] == YES) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    self.tooltipRows = [[NSMutableArray alloc] init];
    self.validation = NO;
    self.confirmedPaymentProducts = [[NSMutableSet alloc] init];
    
    self.inputData = [OPPaymentProductInputData new];
    self.inputData.paymentItem = self.paymentItem;
    self.inputData.accountOnFile = self.accountOnFile;
    if ([self.paymentItem isKindOfClass:[OPPaymentProduct class]]) {
        OPPaymentProduct *product = (OPPaymentProduct *) self.paymentItem;
        [self.confirmedPaymentProducts addObject:product.identifier];
        self.initialPaymentProduct = product;
    }
    
    [self initializeFormRows];
    [self addExtraRows];
    
    self.switching = NO;
    self.coBrandsCollapsed = YES;
    
    [self registerReuseIdentifiers];
}

- (void)registerReuseIdentifiers {
    [self.tableView registerClass:[OPTextFieldTableViewCell class] forCellReuseIdentifier:[OPTextFieldTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPButtonTableViewCell class] forCellReuseIdentifier:[OPButtonTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPCurrencyTableViewCell class] forCellReuseIdentifier:[OPCurrencyTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPSwitchTableViewCell class] forCellReuseIdentifier:[OPSwitchTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPDatePickerTableViewCell class] forCellReuseIdentifier:[OPDatePickerTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPLabelTableViewCell class] forCellReuseIdentifier:[OPLabelTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPPickerViewTableViewCell class] forCellReuseIdentifier:[OPPickerViewTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPReadonlyReviewTableViewCell class] forCellReuseIdentifier:[OPReadonlyReviewTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPErrorMessageTableViewCell class] forCellReuseIdentifier:[OPErrorMessageTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPTooltipTableViewCell class] forCellReuseIdentifier:[OPTooltipTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPPaymentProductTableViewCell class] forCellReuseIdentifier:[OPPaymentProductTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPCoBrandsSelectionTableViewCell class] forCellReuseIdentifier:[OPCoBrandsSelectionTableViewCell reuseIdentifier]];
    [self.tableView registerClass:[OPCOBrandsExplanationTableViewCell class] forCellReuseIdentifier:[OPCOBrandsExplanationTableViewCell reuseIdentifier]];
}

- (void)initializeHeader {
    NSBundle *sdkBundle = [NSBundle bundleWithPath:OPSDKConstants.kOPSDKBundlePath];
    self.header = (OPSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:OPSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.total", OPSDKConstants.kOPSDKLocalizable, sdkBundle, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.context.amountOfMoney.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTableInBundle(@"gc.app.general.securePaymentText", OPSDKConstants.kOPSDKLocalizable, sdkBundle, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

- (void)addExtraRows {
    if ([self.paymentItem isKindOfClass:[OPBasicPaymentProduct class]] && ((OPBasicPaymentProduct *)self.paymentItem).allowsTokenization && self.accountOnFile == nil) {
        // Add remember me switch
          OPFormRowSwitch *switchFormRow = [[OPFormRowSwitch alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"Explanation of the switch for remembering payment information.") isOn:self.rememberPaymentDetails target:self action: @selector(switchChanged:)];
        switchFormRow.isEnabled = true;
        [self.formRows addObject:switchFormRow];
        
        OPFormRowTooltip *switchFormRowTooltip = [OPFormRowTooltip new];
        switchFormRowTooltip.text = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.rememberMe.tooltip", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"");
        switchFormRow.tooltip = switchFormRowTooltip;
        [self.formRows addObject:switchFormRowTooltip];
    }
    
    // Add pay and cancel button
    NSString *payButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.payButton", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"");
    OPFormRowButton *payButtonFormRow = [[OPFormRowButton alloc] initWithTitle: payButtonTitle target: self action: @selector(payButtonTapped)];
    payButtonFormRow.isEnabled = [self.paymentItem isKindOfClass:[OPPaymentProduct class]];
    [self.formRows addObject:payButtonFormRow];
    
    NSString *cancelButtonTitle = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductDetails.cancelButton", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"");
    OPFormRowButton *cancelButtonFormRow = [[OPFormRowButton alloc] initWithTitle: cancelButtonTitle target: self action: @selector(cancelButtonTapped)];
    cancelButtonFormRow.buttonType = OPButtonTypeSecondary;
    cancelButtonFormRow.isEnabled = true;
    [self.formRows addObject:cancelButtonFormRow];
}

- (void)initializeFormRows {
    OPFormRowsConverter *mapper = [OPFormRowsConverter new];
    NSMutableArray *formRows = [mapper formRowsFromInputData: self.inputData viewFactory: self.viewFactory confirmedPaymentProducts: self.confirmedPaymentProducts];
    
    NSMutableArray *formRowsWithTooltip = [NSMutableArray new];
    for (OPFormRow *row in formRows) {
        [formRowsWithTooltip addObject:row];
        if (row != nil && [row isKindOfClass: [OPFormRowWithInfoButton class]]) {
            OPFormRowWithInfoButton *infoButtonRow = (OPFormRowWithInfoButton *)row;
            if (infoButtonRow.tooltip != nil) {
                OPFormRowTooltip *tooltipRow = infoButtonRow.tooltip;
                [formRowsWithTooltip addObject:tooltipRow];
            }
        }
    }
    
    self.formRows = formRowsWithTooltip;
}

- (void)addCoBrandFormsInFormRows:(NSMutableArray *)formRows iinDetailsResponse:(OPIINDetailsResponse *)iinDetailsResponse {
    NSMutableArray *coBrands = [NSMutableArray new];
    for (OPIINDetail *coBrand in iinDetailsResponse.coBrands) {
        if (coBrand.isAllowedInContext) {
            [coBrands addObject:coBrand.paymentProductId];
        }
    }
    if (coBrands.count > 1) {
        if (!self.coBrandsCollapsed) {
            NSBundle *sdkBundle = [NSBundle bundleWithPath:OPSDKConstants.kOPSDKBundlePath];
            
            //Add explanation row
            OPFormRowCoBrandsExplanation *explanationRow = [OPFormRowCoBrandsExplanation new];
            [formRows addObject:explanationRow];
            
            //Add row for selection coBrands
            for (NSString *id in coBrands) {
                OPPaymentProductsTableRow *row = [[OPPaymentProductsTableRow alloc] init];
                row.paymentProductIdentifier = id;
                
                NSString *paymentProductKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", id];
                NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, OPSDKConstants.kOPSDKLocalizable, sdkBundle, nil);
                row.name = paymentProductValue;

                UIImage *paymentItemLogo = self.paymentItem.displayHintsList[0].logoImage;
                [row setLogo:paymentItemLogo];
                
                [formRows addObject:row];
            }
        }
        
        OPFormRowCoBrandsSelection *toggleCoBrandRow = [OPFormRowCoBrandsSelection new];
        [formRows addObject:toggleCoBrandRow];
    }
}

- (void)switchToPaymentProduct:(NSString *)paymentProductId {
    if (paymentProductId != nil) {
        [self.confirmedPaymentProducts addObject:paymentProductId];
    }
    if (paymentProductId == nil) {
        if ([self.confirmedPaymentProducts containsObject:self.paymentItem.identifier]) {
            [self.confirmedPaymentProducts removeObject:self.paymentItem.identifier];
        }
        [self updateFormRows];
    }
    else if ([paymentProductId isEqualToString:self.paymentItem.identifier]) {
        [self updateFormRows];
    }
    else if (self.switching == NO) {
        self.switching = YES;
        [self.session paymentProductWithId:paymentProductId context:self.context success:^(OPPaymentProduct *paymentProduct) {
            self.paymentItem = paymentProduct;
            self.inputData.paymentItem = paymentProduct;
            [self updateFormRows];
            self.switching = NO;
        } failure:^(NSError *error) {
        } apiFailure:^(OPErrorResponse *errorResponse) {
        }];
    }
}

- (void)updateFormRows {
    [self.tableView beginUpdates];
    for (int i = 0; i < self.formRows.count; i++) {
        OPFormRow *row = self.formRows[i];
        if ([row isKindOfClass:[OPFormRowTextField class]]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[OPTextFieldTableViewCell class]]) {
                [self updateTextFieldCell: (OPTextFieldTableViewCell *)cell row: (OPFormRowTextField *)row];
            }
            
        } else if ([row isKindOfClass:[OPFormRowList class]]) {
            OPPickerViewTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [self updatePickerCell:cell row:row];
        } else if ([row isKindOfClass:[OPFormRowSwitch class]]) {
            if (((OPFormRowSwitch *)row).action == @selector(switchChanged:)) {
                row.isEnabled = self.paymentItem != nil && [self.paymentItem isKindOfClass:[OPBasicPaymentProduct class]] && ((OPBasicPaymentProduct *)self.paymentItem).allowsTokenization && self.accountOnFile == nil;
                continue;
            }
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[OPSwitchTableViewCell class]]) {
                [self updateSwitchCell:(OPSwitchTableViewCell *)cell row:(OPFormRowSwitch *)row];
            }
        } else if ([row isKindOfClass:[OPFormRowButton class]] &&  ((OPFormRowButton *)row).action == @selector(payButtonTapped)) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell != nil && [cell isKindOfClass:[OPButtonTableViewCell class]]) {
                row.isEnabled = [self.paymentItem isKindOfClass:[OPPaymentProduct class]];
                [self updateButtonCell: (OPButtonTableViewCell *)cell row: (OPFormRowButton *)row];
            }
        }
    }
    [self.tableView endUpdates];
    
}

- (void)updateTextFieldCell:(OPTextFieldTableViewCell *)cell row: (OPFormRowTextField *)row {
    // Add error messages for cells
    OPValidationError *error = [row.paymentProductField.errorMessageIds firstObject];
    cell.delegate = self;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    cell.field = row.field;
    cell.readonly = !row.isEnabled;
    if (error != nil) {
        cell.error = [OPFormRowsConverter errorMessageForError: error withCurrency: row.paymentProductField.displayHints.formElement.type == OPCurrencyType];
    } else {
        cell.error = nil;
    }
}

- (void)updateSwitchCell:(OPSwitchTableViewCell *)cell row: (OPFormRowSwitch *)row {
    // Add error messages for cells
    if (row.field == nil) {
        return;
    }
    OPValidationError *error = [row.field.errorMessageIds firstObject];
    if (error != nil) {
        cell.errorMessage = [OPFormRowsConverter errorMessageForError: error withCurrency: NO];
    } else {
        cell.errorMessage = nil;
    }
}

- (void)updateButtonCell:(OPButtonTableViewCell *)cell row:(OPFormRowButton *)row {
    cell.isEnabled = row.isEnabled;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.formRows.count;
}

// TODO: indexPath argument is not used, maybe replace it with tableView
- (OPTableViewCell *)formRowCellForRow:(OPFormRow *)row atIndexPath:(NSIndexPath *)indexPath {
    Class class = [row class];
    OPTableViewCell *cell = nil;
    if (class == [OPFormRowTextField class]) {
        cell = [self cellForTextField:(OPFormRowTextField *)row tableView:self.tableView];
    } else if (class == [OPFormRowCurrency class]) {
        cell = [self cellForCurrency:(OPFormRowCurrency *) row tableView:self.tableView];
    } else if (class == [OPFormRowSwitch class]) {
        cell = [self cellForSwitch:(OPFormRowSwitch *)row tableView:self.tableView];
    } else if (class == [OPFormRowList class]) {
        cell = [self cellForList:(OPFormRowList *)row tableView:self.tableView];
    } else if (class == [OPFormRowButton class]) {
        cell = [self cellForButton:(OPFormRowButton *)row tableView:self.tableView];
    } else if (class == [OPFormRowLabel class]) {
        cell = [self cellForLabel:(OPFormRowLabel *)row tableView:self.tableView];
    } else if (class == [OPFormRowDate class]) {
        cell = [self cellForDatePicker:(OPFormRowDate *)row tableView:self.tableView];
    } else if (class == [OPFormRowErrorMessage class]) {
        cell = [self cellForErrorMessage:(OPFormRowErrorMessage *)row tableView:self.tableView];
    } else if (class == [OPFormRowTooltip class]) {
        cell = [self cellForTooltip:(OPFormRowTooltip *)row tableView:self.tableView];
    } else if (class == [OPFormRowCoBrandsSelection class]) {
        cell = [self cellForCoBrandsSelection:(OPFormRowCoBrandsSelection *)row tableView:self.tableView];
    } else if (class == [OPFormRowCoBrandsExplanation class]) {
        cell = [self cellForCoBrandsExplanation:(OPFormRowCoBrandsExplanation  *)row tableView:self.tableView];
    } else if (class == [OPPaymentProductsTableRow class]) {
        cell = [self cellForPaymentProduct:(OPPaymentProductsTableRow  *)row tableView:self.tableView];
    } else if (class == [OPFormRowReadonlyReview class]) {
        cell = [self cellForReadonlyReview:(OPFormRowReadonlyReview  *)row tableView:self.tableView];
    } else {
        [NSException raise:@"Invalid form row class" format:@"Form row class %@ is invalid", class];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OPFormRow *row = self.formRows[indexPath.row];
    OPTableViewCell *cell = [self formRowCellForRow:row atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Helper methods for data source methods

- (OPReadonlyReviewTableViewCell *)cellForReadonlyReview:(OPFormRowReadonlyReview *)row tableView:(UITableView *)tableView {
    OPReadonlyReviewTableViewCell *cell = (OPReadonlyReviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPReadonlyReviewTableViewCell reuseIdentifier]];
    
    cell.data = row.data;
    return cell;
}

- (OPTextFieldTableViewCell *)cellForTextField:(OPFormRowTextField *)row tableView:(UITableView *)tableView {
    OPTextFieldTableViewCell *cell = (OPTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPTextFieldTableViewCell reuseIdentifier]];
    
    [self updateTextFieldCell:cell row:row];
    
    return cell;
}

- (OPDatePickerTableViewCell *)cellForDatePicker:(OPFormRowDate *)row tableView:(UITableView *)tableView {
    OPDatePickerTableViewCell *cell = (OPDatePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPDatePickerTableViewCell reuseIdentifier]];
    
    cell.delegate = self;
    cell.readonly = !row.isEnabled;
    cell.date = row.date;
    return cell;
}

- (OPCurrencyTableViewCell *)cellForCurrency:(OPFormRowCurrency *)row tableView:(UITableView *)tableView {
    OPCurrencyTableViewCell *cell = (OPCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPCurrencyTableViewCell reuseIdentifier]];
    cell.integerField = row.integerField;
    cell.delegate = self;
    cell.fractionalField = row.fractionalField;
    cell.readonly = !row.isEnabled;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (OPSwitchTableViewCell *)cellForSwitch:(OPFormRowSwitch *)row tableView:(UITableView *)tableView {
    OPSwitchTableViewCell *cell = (OPSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPSwitchTableViewCell reuseIdentifier]];
    cell.attributedTitle = row.title;
    [cell setSwitchTarget:row.target action:row.action];
    cell.on = row.isOn;
    cell.delegate = self;
    OPValidationError *error = [row.field.errorMessageIds firstObject];
    if (error != nil && self.validation) {
        cell.errorMessage = [OPFormRowsConverter errorMessageForError: error withCurrency: 0];
    }
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (OPPickerViewTableViewCell *)cellForList:(OPFormRowList *)row tableView:(UITableView *)tableView {
    OPPickerViewTableViewCell *cell = (OPPickerViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPPickerViewTableViewCell reuseIdentifier]];
    cell.items = row.items;
    cell.delegate = self;
    cell.dataSource = self;
    cell.selectedRow = row.selectedRow;
    cell.readonly = !row.isEnabled;
    return cell;
}

- (OPButtonTableViewCell *)cellForButton:(OPFormRowButton *)row tableView:(UITableView *)tableView {
    OPButtonTableViewCell *cell = (OPButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPButtonTableViewCell reuseIdentifier]];
    cell.buttonType = row.buttonType;
    cell.isEnabled = row.isEnabled;
    cell.title = row.title;
    [cell setClickTarget:row.target action:row.action];
    return cell;
}

- (OPLabelTableViewCell *)cellForLabel:(OPFormRowLabel *)row tableView:(UITableView *)tableView {
    OPLabelTableViewCell *cell = (OPLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPLabelTableViewCell reuseIdentifier]];
    cell.label = row.text;
    cell.bold = row.bold;
    cell.accessoryType = row.showInfoButton ? UITableViewCellAccessoryDetailButton : UITableViewCellAccessoryNone;
    return cell;
}

- (OPErrorMessageTableViewCell *)cellForErrorMessage:(OPFormRowErrorMessage *)row tableView:(UITableView *)tableView {
    OPErrorMessageTableViewCell *cell = (OPErrorMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPErrorMessageTableViewCell reuseIdentifier]];
    cell.textLabel.text = row.text;
    return cell;
}

- (OPTooltipTableViewCell *)cellForTooltip:(OPFormRowTooltip *)row tableView:(UITableView *)tableView {
    OPTooltipTableViewCell *cell = (OPTooltipTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPTooltipTableViewCell reuseIdentifier]];
    cell.label = row.text;
    cell.tooltipImage = row.image;
    return cell;
}

- (OPCoBrandsSelectionTableViewCell *)cellForCoBrandsSelection:(OPFormRowCoBrandsSelection *)row tableView:(UITableView *)tableView {
    OPCoBrandsSelectionTableViewCell *cell = (OPCoBrandsSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPCoBrandsSelectionTableViewCell reuseIdentifier]];
    return cell;
}


- (OPCOBrandsExplanationTableViewCell *)cellForCoBrandsExplanation:(OPFormRowCoBrandsExplanation *)row tableView:(UITableView *)tableView {
    OPCOBrandsExplanationTableViewCell *cell = (OPCOBrandsExplanationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPCOBrandsExplanationTableViewCell reuseIdentifier]];
    return cell;
}

- (OPPaymentProductTableViewCell *)cellForPaymentProduct:(OPPaymentProductsTableRow *)row tableView:(UITableView *)tableView {
    OPPaymentProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OPPaymentProductTableViewCell reuseIdentifier]];
    cell.name = row.name;
    cell.logo = row.logo;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [cell setNeedsLayout];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OPFormRow *row = self.formRows[indexPath.row];
    
    if ([row isKindOfClass:[OPFormRowList class]]) {
        return [OPPickerViewTableViewCell pickerHeight];
    }
    else if ([row isKindOfClass:[OPFormRowDate class]]) {
        return [OPDatePickerTableViewCell pickerHeight];
    }
    // Rows that you can toggle
    else if ([row isKindOfClass:[OPFormRowTooltip class]] && !row.isEnabled) {
        return 0;
    }
    else if ([row isKindOfClass:[OPFormRowSwitch class]] && ((OPFormRowSwitch *)row).action == @selector(switchChanged:) && !row.isEnabled) {
        return 0;
    }
    else if ([row isKindOfClass:[OPFormRowTooltip class]] && ((OPFormRowTooltip *)row).image != nil) {
        return 145;
    } else if ([row isKindOfClass:[OPFormRowTooltip class]]) {
        return [OPTooltipTableViewCell cellSizeForWidth:MIN(320, tableView.frame.size.width) forFormRow:(OPFormRowTooltip *)row].height;
    }
    else if ([row isKindOfClass:[OPFormRowLabel class]]) {
        CGFloat tableWidth = tableView.frame.size.width;
        CGFloat height = [OPLabelTableViewCell cellSizeForWidth:MIN(320, tableWidth) forFormRow:(OPFormRowLabel *)row].height;
        return height;
    } else if ([row isKindOfClass:[OPFormRowButton class]]) {
        return 52;
    } else if ([row isKindOfClass:[OPFormRowTextField class]]) {
        CGFloat width = tableView.bounds.size.width - 20;
        OPFormRowTextField *textfieldRow = (OPFormRowTextField *)row;
        if (textfieldRow.showInfoButton) {
            width -= 48;
        }
        CGFloat errorHeight = 0;

        if ([textfieldRow.paymentProductField.errorMessageIds firstObject] && self.validation) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@""];
            str = [[NSAttributedString alloc] initWithString: [OPFormRowsConverter errorMessageForError:[textfieldRow.paymentProductField.errorMessageIds firstObject]   withCurrency: textfieldRow.paymentProductField.displayHints.formElement.type == OPCurrencyType]];
            errorHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin context: nil].size.height;
        }
        
        CGFloat height =  44 + errorHeight;
        return height;
        
    } else if ([row isKindOfClass:[OPFormRowSwitch class]]) {
        CGFloat width = tableView.bounds.size.width - 20;
        OPFormRowSwitch *textfieldRow = (OPFormRowSwitch *)row;
        if (textfieldRow.showInfoButton) {
            width -= 48;
        }
        CGFloat errorHeight = 0;
        if ([textfieldRow.field.errorMessageIds firstObject] && self.validation) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@""];
            str = [[NSAttributedString alloc] initWithString: [OPFormRowsConverter errorMessageForError:[textfieldRow.field.errorMessageIds firstObject]   withCurrency: 0]];
            errorHeight = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin context: nil].size.height + 10;
        }
    
        CGFloat height =  10 + 44 + 10 + errorHeight;
        return height;
    }

    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.formRows[indexPath.row] isKindOfClass:[OPFormRowCoBrandsSelection class]]) {
        self.coBrandsCollapsed = !self.coBrandsCollapsed;
        [self.tableView reloadData];
    } else if ([self.formRows[indexPath.row] isKindOfClass:[OPPaymentProductsTableRow class]]) {
        OPPaymentProductsTableRow *row = (OPPaymentProductsTableRow *)self.formRows[indexPath.row];
        [self switchToPaymentProduct:row.paymentProductIdentifier];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    OPFormRow *formRow = self.formRows[indexPath.row + 1];
    if ([formRow isKindOfClass:[OPFormRowTooltip class]]) {
        
        formRow.isEnabled = !formRow.isEnabled;
        
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

#pragma mark TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL result = false;
    if ([textField class] == [OPTextField class]) {
        result = [self standardTextField:(OPTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [OPIntegerTextField class]) {
        result = [self integerTextField:(OPIntegerTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    } else if ([textField class] == [OPFractionalTextField class]) {
        result = [self fractionalTextField:(OPFractionalTextField *)textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if (self.validation) {
        [self validateData];
    }
    
    return result;
}
- (void)formatAndUpdateCharactersFromTextField:(UITextField *)textField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath {
    OPFormRowTextField *row = (OPFormRowTextField *)self.formRows[indexPath.row];
    NSMutableCharacterSet *trimSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" /-_"];
    NSString *formattedString = [[self.inputData maskedValueForField:row.paymentProductField.identifier cursorPosition:position] stringByTrimmingCharactersInSet: trimSet];
    row.field.text = formattedString;
    textField.text = formattedString;
    *position = MIN(*position, formattedString.length);
    UITextPosition *cursorPositionInTextField = [textField positionFromPosition:textField.beginningOfDocument offset:*position];
    [textField setSelectedTextRange:[textField textRangeFromPosition:cursorPositionInTextField toPosition:cursorPositionInTextField]];
}

- (BOOL)standardTextField:(OPTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[OPFormRowTextField class]]) {
        return NO;
    }
    OPFormRowTextField *row = (OPFormRowTextField *)self.formRows[indexPath.row];
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.inputData setValue:newString forField:row.paymentProductField.identifier];
    row.field.text = [self.inputData maskedValueForField:row.paymentProductField.identifier];
    NSInteger cursorPosition = range.location + string.length;
    [self formatAndUpdateCharactersFromTextField:textField cursorPosition:&cursorPosition indexPath:indexPath];
    return NO;
}

- (BOOL)integerTextField:(OPIntegerTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[OPFormRowCurrency class]]) {
        return NO;
    }
    OPFormRowCurrency *row = (OPFormRowCurrency *)self.formRows[indexPath.row];
    NSString *integerString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *fractionalString = row.fractionalField.text;
    
    if (integerString.length > 16) {
        return NO;
    }
    
    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (BOOL)fractionalTextField:(OPFractionalTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![textField.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)textField.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[OPFormRowCurrency class]]) {
        return NO;
    }
    OPFormRowCurrency *row = (OPFormRowCurrency *)self.formRows[indexPath.row];
    NSString *integerString = row.integerField.text;
    NSString *fractionalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (fractionalString.length > 2) {
        int start = (int) fractionalString.length - 2;
        int end = (int) fractionalString.length - 1;
        fractionalString = [fractionalString substringWithRange:NSMakeRange(start, end)];
    }
    
    NSString *newValue = [self updateCurrencyValueWithIntegerString:integerString fractionalString:fractionalString paymentProductFieldIdentifier:row.paymentProductField.identifier];
    if (string.length == 0) {
        return YES;
    } else {
        [self updateRowWithCurrencyValue:newValue formRowCurrency:row];
        return NO;
    }
}

- (NSString *)updateCurrencyValueWithIntegerString:(NSString *)integerString fractionalString:(NSString *)fractionalString paymentProductFieldIdentifier:(NSString *)identifier {
    long long integerPart = [integerString longLongValue];
    int fractionalPart = [fractionalString intValue];
    long long newValue = integerPart * 100 + fractionalPart;
    NSString *newString = [NSString stringWithFormat:@"%03lld", newValue];
    [self.inputData setValue:newString forField:identifier];
    
    return newString;
}

- (void)updateRowWithCurrencyValue:(NSString *)currencyValue formRowCurrency:(OPFormRowCurrency *)formRowCurrency {
    formRowCurrency.integerField.text = [currencyValue substringToIndex:currencyValue.length - 2];
    formRowCurrency.fractionalField.text = [currencyValue substringFromIndex:currencyValue.length - 2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

- (void)validateData {
    [self.inputData validate];
    [self updateFormRows];
}

#pragma mark Date picker cell delegate

- (void)datePicker:(UIDatePicker *)datePicker selectedNewDate:(NSDate *)newDate {
    OPDatePickerTableViewCell *cell = (OPDatePickerTableViewCell *)[datePicker superview];
    NSIndexPath *path = [[self tableView]indexPathForCell:cell];
    OPFormRowDate *row = self.formRows[path.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:newDate];
    [self.inputData setValue:dateString forField:row.paymentProductField.identifier] ;
    
}

- (void)cancelButtonTapped {
    [self.paymentRequestTarget didCancelPaymentRequest];
}


- (void)switchChanged:(OPSwitch *)sender
{
    OPSwitchTableViewCell *cell = (OPSwitchTableViewCell *)sender.superview;
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    OPFormRowSwitch *row = self.formRows[ip.row];
    OPPaymentProductField *field = [row field];
    
    if (field == nil) {
        self.inputData.tokenize = sender.on;
    }
    else {
        [self.inputData setValue:[sender isOn] ? @"true" : @"false" forField:field.identifier];
        row.isOn = [sender isOn];
        if (self.validation) {
            [self validateData];
        }
        [self updateSwitchCell:cell row:row];
    }
}

#pragma mark Picker view delegate

- (NSInteger)numberOfComponentsInPickerView:(OPPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(OPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerView.content.count;
}

- (NSAttributedString *)pickerView:(OPPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *item = pickerView.content[row];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:item];
    return string;
}

- (void)pickerView:(OPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (![pickerView.superview isKindOfClass:[OPPickerViewTableViewCell class]]) {
        return;
    }
    OPPickerViewTableViewCell *cell = (OPPickerViewTableViewCell *)pickerView.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)pickerView.superview];
    if (indexPath == nil || ![self.formRows[indexPath.row] isKindOfClass:[OPFormRowList class]]) {
        return;
    }
    OPFormRowList *element = (OPFormRowList *)self.formRows[indexPath.row];
    OPValueMappingItem *selectedItem = cell.items[row];
    
    element.selectedRow = row;
    [self.inputData setValue:selectedItem.value forField:element.paymentProductField.identifier];
}

// To be overrided by subclasses
- (void)updatePickerCell:(OPPickerViewTableViewCell *)cell row: (OPFormRowList *)list {
    return;
}

#pragma mark Button target methods

- (void)payButtonTapped {
    BOOL valid = NO;
    
    [self.inputData validate];
    if (self.inputData.errors.count == 0) {
        [self.inputData createPaymentRequest];

        OPPaymentRequest *paymentRequest = self.inputData.paymentRequest;

        NSArray<OPValidationError *> *errorMessageIds = [paymentRequest validate];
        if (errorMessageIds.count == 0) {
            valid = YES;
            [self.paymentRequestTarget didSubmitPaymentRequest:paymentRequest];
        }
    }
    if (valid == NO) {
        self.validation = YES;
        [self updateFormRows];
    }
    
}

- (void)validateExceptFields:(NSSet *)fields {
    [self.inputData validateExceptFields:fields];
    if (self.inputData.errors.count > 0) {
        self.validation = YES;
    }
}

@end
