//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPCardProductViewController.h"

#import "OPFormRowTextField.h"
#import "OPFormRowCoBrandsExplanation.h"
#import "OPFormRowCoBrandsSelection.h"
#import "OPPaymentProductsTableRow.h"
#import "OPPaymentProductTableViewCell.h"
#import "OPCOBrandsExplanationTableViewCell.h"
#import "OPPaymentProductInputData.h"

@import OnlinePaymentsKit;

@interface OPCardProductViewController ()

@property (nonatomic, strong) UITextPosition *cursorPositionInCreditCardNumberTextField;
@property (nonatomic, strong) OPIINDetailsResponse *iinDetailsResponse;
@property (strong, nonatomic) NSBundle *sdkBundle;
@property (strong, nonatomic) NSArray<OPIINDetail *> *cobrands;
@property (strong, nonatomic) NSString *previousEnteredCreditCardNumber;

@end

@implementation OPCardProductViewController

- (void)viewDidLoad {
    self.sdkBundle = [NSBundle bundleWithPath:OPSDKConstants.kOPSDKBundlePath];
    [super viewDidLoad];
    
}

- (void)registerReuseIdentifiers {
    [super registerReuseIdentifiers];
    [self.tableView registerClass:[OPCoBrandsSelectionTableViewCell class] forCellReuseIdentifier:OPCoBrandsSelectionTableViewCell.reuseIdentifier];
    [self.tableView registerClass:[OPCOBrandsExplanationTableViewCell class] forCellReuseIdentifier:OPCOBrandsExplanationTableViewCell.reuseIdentifier];
    [self.tableView registerClass:[OPPaymentProductTableViewCell class] forCellReuseIdentifier:OPPaymentProductTableViewCell.reuseIdentifier];
}

- (void) updateTextFieldCell:(OPTextFieldTableViewCell *)cell row: (OPFormRowTextField *)row {
    [super updateTextFieldCell:cell row:row];
    if ([row.paymentProductField.identifier isEqualToString:@"cardNumber"]) {
        if([self.confirmedPaymentProducts containsObject:self.paymentItem.identifier]) {
            CGFloat productIconSize = 35.2;
            CGFloat padding = 4.4;

            UIView *outerView = [[UIView alloc]initWithFrame:CGRectMake(padding, padding, productIconSize, productIconSize)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, productIconSize, productIconSize)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [outerView addSubview:imageView];
            outerView.contentMode = UIViewContentModeScaleAspectFit;
            
            imageView.image = row.logo;
            cell.rightView = outerView;
        } else {
            row.logo = nil;
            cell.rightView = [[UIView alloc]init];
        }
    }
}

- (OPCoBrandsSelectionTableViewCell *)cellForCoBrandsSelection:(OPFormRowCoBrandsSelection *)row tableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:OPCoBrandsSelectionTableViewCell.reuseIdentifier];
}

- (OPCOBrandsExplanationTableViewCell *)cellForCoBrandsExplanation:(OPFormRowCoBrandsExplanation *)row tableView:(UITableView *)tableView {
    return [tableView dequeueReusableCellWithIdentifier:OPCOBrandsExplanationTableViewCell.reuseIdentifier];
}

- (OPPaymentProductTableViewCell *)cellForPaymentProduct:(OPPaymentProductsTableRow *)row tableView:(UITableView *)tableView {
    OPPaymentProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OPPaymentProductTableViewCell.reuseIdentifier];
    
    cell.name = row.name;
    cell.logo = row.logo;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.shouldHaveMaximalWidth = YES;
    cell.limitedBackgroundColor = [UIColor colorWithWhite: 0.9 alpha: 1];
    [cell setNeedsLayout];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    OPFormRow *row = [self.formRows objectAtIndex:indexPath.row];
    if ([row isKindOfClass:[OPPaymentProductsTableRow class]] && ((OPPaymentProductsTableRow *)row).paymentProductIdentifier != self.paymentItem.identifier) {
        [self switchToPaymentProduct:((OPPaymentProductsTableRow *)row).paymentProductIdentifier];
        return;
    }
    if ([row isKindOfClass:[OPFormRowCoBrandsSelection class]] || [row isKindOfClass:[OPPaymentProductsTableRow class]]) {
        for (OPFormRow *cell in self.formRows) {
            if ([cell isKindOfClass:[OPFormRowCoBrandsExplanation class]] || [cell isKindOfClass:[OPPaymentProductsTableRow class]]) {
                cell.isEnabled = !cell.isEnabled;
            }
        }
        [self updateFormRows];
    }
}

- (void)formatAndUpdateCharactersFromTextField:(UITextField *)texField cursorPosition:(NSInteger *)position indexPath:(NSIndexPath *)indexPath {
    [super formatAndUpdateCharactersFromTextField:texField cursorPosition:position indexPath:indexPath];
    OPFormRowTextField *row = [self.formRows objectAtIndex:indexPath.row];
    if ([row.paymentProductField.identifier isEqualToString:@"cardNumber"]) {
        NSString *unmasked = [self.inputData unmaskedValueForField:row.paymentProductField.identifier];
        if (unmasked.length >= 6 && [self oneOfFirst8DigitsChangedInText:unmasked]) {
            
            [self.session IINDetailsForPartialCreditCardNumber:unmasked context:self.context success:^(OPIINDetailsResponse *response) {
                self.iinDetailsResponse = response;
                if ([self.inputData unmaskedValueForField:row.paymentProductField.identifier].length < 6) {
                    return;
                }
                self.cobrands = response.coBrands;

                if (response.status == OPSupported) {
                    BOOL coBrandSelected = NO;
                    for (OPIINDetail *coBrand in response.coBrands) {
                        if ([coBrand.paymentProductId isEqualToString:self.paymentItem.identifier]) {
                            coBrandSelected = YES;
                        }
                    }
                    if (coBrandSelected == NO) {
                        [self switchToPaymentProduct:response.paymentProductId];
                    }
                    else {
                        [self switchToPaymentProduct:self.paymentItem.identifier];
                    }
                }
                else {
                    [self switchToPaymentProduct:self.initialPaymentProduct == nil ? nil : self.initialPaymentProduct.identifier];
                }
            } failure:^(NSError *error) {
                
            }];
        }
        _previousEnteredCreditCardNumber = unmasked;
    }
}

- (BOOL)oneOfFirst8DigitsChangedInText:(NSString *)currentEnteredCreditCardNumber {
    // Add some padding, so we are sure there are 8 characters to compare.
    NSString *currentPadded = [currentEnteredCreditCardNumber stringByAppendingString: @"xxxxxxxx"];
    NSString *previousPadded = [_previousEnteredCreditCardNumber stringByAppendingString:@"xxxxxxxx"];

    NSString *currentFirst8 = [currentPadded substringWithRange:NSMakeRange(0, 8)];
    NSString *previousFirst8 = [previousPadded substringWithRange:NSMakeRange(0, 8)];

    return ![currentFirst8 isEqualToString:previousFirst8];
}

- (void)initializeFormRows {
    [super initializeFormRows];
    NSArray<OPFormRow *> *newFormRows = [self coBrandFormsWithIINDetailsResponse:self.cobrands];
    [self.formRows insertObjects:newFormRows atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, newFormRows.count)]];
}

- (void)updateFormRows {
    if ([self switching]) {
        // We need to update the tableView to the new amount of rows. However, we cannot use tableView.reloadData(), because then
        // the current textfield losses focus. We also should not reload the cardNumber row with tableView.reloadRows([indexOfCardNumber, with: ...)
        // because that also makes the textfield lose focus.
        
        // Because the cardNumber field might move, we cannot just insert/delete the difference in rows in general, because if we
        // do, the index of the cardNumber field might change, and we cannot reload the new place.
        
        // So instead, we check the difference in rows before the cardNumber field between before the mutation and after the mutation,
        // and the difference in rows after the cardNumber field between before and after the mutations
        
        [self.tableView beginUpdates];
        NSArray<OPFormRow *> *oldFormRows = self.formRows;
        [self initializeFormRows];
        [self addExtraRows];
        
        NSInteger oldCardNumberIndex = 0;
        for (OPFormRow *fr in oldFormRows) {
            if ([fr isKindOfClass:[OPFormRowTextField class]]) {
                if ([((OPFormRowTextField *)fr).paymentProductField.identifier isEqualToString:@"cardNumber"]) {
                    break;
                }
            }
            oldCardNumberIndex += 1;
        }
        NSInteger newCardNumberIndex = 0;
        for (OPFormRow *fr in self.formRows) {
            if ([fr isKindOfClass:[OPFormRowTextField class]]) {
                if ([((OPFormRowTextField *)fr).paymentProductField.identifier isEqualToString:@"cardNumber"]) {
                    break;
                }
            }
            newCardNumberIndex += 1;
        }
        if (newCardNumberIndex >= self.formRows.count) {
            newCardNumberIndex = 0;
        }
        if (oldCardNumberIndex >= self.formRows.count) {
            oldCardNumberIndex = 0;
        }
        NSInteger diffCardNumberIndex = newCardNumberIndex - oldCardNumberIndex;
        if (diffCardNumberIndex >= 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:diffCardNumberIndex];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:oldCardNumberIndex];
            for (NSInteger i = 0; i < diffCardNumberIndex; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:oldCardNumberIndex - 1 + i inSection:0]];
            }
            for (NSInteger i = 0; i < oldCardNumberIndex; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (diffCardNumberIndex < 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:-diffCardNumberIndex];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:oldCardNumberIndex];
            for (NSInteger i = 0; i < -diffCardNumberIndex; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            for (NSInteger i = 0; i < oldCardNumberIndex + diffCardNumberIndex; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:oldCardNumberIndex - i inSection:0]];
            }
            
            [self.tableView deleteRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        NSInteger oldAfterCardNumberCount = oldFormRows.count - oldCardNumberIndex - 1;
        NSInteger newAfterCardNumberCount = self.formRows.count - newCardNumberIndex - 1;
        
        NSInteger diffAfterCardNumberCount = newAfterCardNumberCount - oldAfterCardNumberCount;
        
        // We cannot not update the cardname field if it doesn't exist
        if (newAfterCardNumberCount < 0) {
            newAfterCardNumberCount = 0;
        }
        if (diffAfterCardNumberCount >= 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:diffAfterCardNumberCount];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:oldAfterCardNumberCount];
            for (NSInteger i = 0; i < diffAfterCardNumberCount; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:oldFormRows.count + i inSection:0]];
            }
            for (NSInteger i = 0; i < oldAfterCardNumberCount; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:i + oldCardNumberIndex + 1 inSection:0]];
            }
            
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if (diffAfterCardNumberCount < 0) {
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:-diffAfterCardNumberCount];
            NSMutableArray *updateIndexPaths = [NSMutableArray arrayWithCapacity:newAfterCardNumberCount];
            for (NSInteger i = 0; i < -diffAfterCardNumberCount; i+=1) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:oldFormRows.count - i - 1 inSection:0]];
            }
            for (NSInteger i = 0; i < newAfterCardNumberCount; i+=1) {
                [updateIndexPaths addObject:[NSIndexPath indexPathForRow:self.formRows.count - i - 1 - diffCardNumberIndex inSection:0]];
            }
            
            [self.tableView deleteRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView reloadRowsAtIndexPaths:updateIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView endUpdates];
    }
    [super updateFormRows];
}

- (NSArray *)coBrandFormsWithIINDetailsResponse: (NSArray<OPIINDetail *> *)inputBrands{
    NSMutableArray *coBrands = [[NSMutableArray alloc] init];
    for (OPIINDetail *coBrand in inputBrands) {
        if (coBrand.isAllowedInContext) {
            [coBrands addObject:coBrand.paymentProductId];
        }
    }
    NSMutableArray *formRows = [[NSMutableArray alloc] init];
    
    if (coBrands.count > 1) {
        // Add explanaton row
        OPFormRowCoBrandsExplanation *explanationRow = [[OPFormRowCoBrandsExplanation alloc]init];
        [formRows addObject:explanationRow];
        
        for (NSString *identifier in coBrands) {
            OPPaymentProductsTableRow *row = [[OPPaymentProductsTableRow alloc]init];
            row.paymentProductIdentifier = identifier;
            
            NSString *paymentProductKey = [NSString stringWithFormat:@"gc.general.paymentProducts.%@.name", identifier];
            NSString *paymentProductValue = NSLocalizedStringFromTableInBundle(paymentProductKey, OPSDKConstants.kOPSDKLocalizable, [NSBundle bundleWithPath:OPSDKConstants.kOPSDKBundlePath], "");
            row.name = paymentProductValue;
            
            OPAssetManager *assetManager = [[OPAssetManager alloc]init];
            UIImage *logo = [assetManager logoImageForPaymentItem:identifier];
            [row setLogo:logo];
            
            [formRows addObject:row];
        }
        OPFormRowCoBrandsSelection *toggleCoBrandRow = [[OPFormRowCoBrandsSelection alloc]init];
        [formRows addObject:toggleCoBrandRow];
    }
    
    return formRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OPFormRow *row = [self.formRows objectAtIndex:[indexPath row]];
    if (([row isKindOfClass:[OPFormRowCoBrandsExplanation class]] || [row isKindOfClass:[OPPaymentProductsTableRow class]]) && ![row isEnabled]) {
        return 0;
    }
    else if ([row isKindOfClass:[OPFormRowCoBrandsExplanation class]]) {
        NSAttributedString *cellString = OPCOBrandsExplanationTableViewCell.cellString;
        CGRect rect = [cellString boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return rect.size.height + 20;
    }
    else if ([row isKindOfClass:[OPFormRowCoBrandsSelection class]]) {
        return 30;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
