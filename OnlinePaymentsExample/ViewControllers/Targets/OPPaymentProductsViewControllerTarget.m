//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import "OPPaymentProductsViewControllerTarget.h"
#import "OPViewFactory.h"
#import "OPCardProductViewController.h"
#import "OPAppConstants.h"
#import "OPBasicPaymentProductGroup.h"
#import "OPPaymentProductGroup.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <OnlinePaymentsSDK/OPSDKConstants.h>

@interface OPPaymentProductsViewControllerTarget ()

@property (strong, nonatomic) OPSession *session;
@property (strong, nonatomic) OPPaymentContext *context;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) OPViewFactory *viewFactory;
@property (strong, nonatomic) OPPaymentProduct *applePayPaymentProduct;
@property (strong, nonatomic) NSArray *summaryItems;
@property (strong, nonatomic) PKPaymentAuthorizationViewController * authorizationViewController;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation OPPaymentProductsViewControllerTarget


- (instancetype)initWithNavigationController:(UINavigationController *)navigationController session:(OPSession *)session context:(OPPaymentContext *)context viewFactory:(OPViewFactory *)viewFactory {
    self = [super init];
    self.navigationController = navigationController;
    self.session = session;
    self.context = context;
    self.viewFactory = viewFactory;
    self.sdkBundle = [NSBundle bundleWithPath:kOPSDKBundlePath];

    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"-init is not a valid initializer for the class OPPaymentProductsViewControllerTarget"
                                 userInfo:nil];
    return nil;
}

#pragma mark PaymentProduct selection target

- (void)didSelectPaymentItem:(NSObject <OPBasicPaymentItem> *)paymentItem accountOnFile:(OPAccountOnFile *)accountOnFile; {
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"gc.app.general.loading.body", kOPSDKLocalizable, [NSBundle bundleWithPath:kOPSDKBundlePath], nil)];
    
    // ***************************************************************************
    //
    // After selecting a payment product or an account on file associated to a
    // payment product in the payment product selection screen, the OPSession
    // object is used to retrieve all information for this payment product.
    //
    // Afterwards, a screen is shown that allows the user to fill in all
    // relevant information, unless the payment product has no fields.
    // This screen is also not part of the SDK and is offered for demonstration
    // purposes only.
    //
    // If the payment product has no fields, the merchant is responsible for
    // fetching the URL for a redirect to a third party and show the corresponding
    // website.
    //
    // ***************************************************************************

    [self.session paymentProductWithId:paymentItem.identifier context:self.context success:^(OPPaymentProduct *paymentProduct) {
        if ([paymentItem.identifier isEqualToString:kOPApplePayIdentifier]) {
            [self showApplePayPaymentItem:paymentProduct];
        } else {
            [SVProgressHUD dismiss];
            if (paymentProduct.fields.paymentProductFields.count > 0) {
                [self showPaymentItem:paymentProduct accountOnFile:accountOnFile];
            } else {
                OPPaymentRequest *request = [[OPPaymentRequest alloc] init];
                request.paymentProduct = paymentProduct;
                request.accountOnFile = accountOnFile;
                request.tokenize = NO;
                [self didSubmitPaymentRequest:request];
            }
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kOPAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"PaymentProductErrorExplanation", kOPAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)showPaymentItem:(NSObject <OPPaymentItem> *)paymentItem accountOnFile:(OPAccountOnFile *)accountOnFile {
    OPPaymentProductViewController *paymentProductForm = nil;
    
    if (([paymentItem isKindOfClass:[OPPaymentProductGroup class]] && [paymentItem.identifier isEqualToString:@"cards"]) || ([paymentItem isKindOfClass:[OPPaymentProduct class]] && [((OPPaymentProduct *)paymentItem).paymentMethod isEqualToString:@"card"])) {
        paymentProductForm = [[OPCardProductViewController alloc] init];

    }
    else {
        paymentProductForm = [[OPPaymentProductViewController alloc] init];
    }
    paymentProductForm.paymentItem = paymentItem;
    paymentProductForm.session = self.session;
    paymentProductForm.context = self.context;
    paymentProductForm.viewFactory = self.viewFactory;
    paymentProductForm.accountOnFile = accountOnFile;
    paymentProductForm.amount = self.context.amountOfMoney.totalAmount;
    
    paymentProductForm.paymentRequestTarget = self;
    [self.navigationController pushViewController:paymentProductForm animated:YES];
}

#pragma mark ApplePay selection handling

- (void)showApplePayPaymentItem:(OPPaymentProduct *)paymentProduct {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [PKPaymentAuthorizationViewController canMakePayments]) {
        [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"gc.app.general.loading.body", kOPSDKLocalizable, [NSBundle bundleWithPath:kOPSDKBundlePath], nil)];
        
        // ***************************************************************************
        //
        // If the payment product is Apple Pay, the supported networks are retrieved.
        //
        // A view controller for Apple Pay will be shown when these networks have been
        // retrieved.
        //
        // ***************************************************************************
        
        [self.session paymentProductNetworksForProductId:kOPApplePayIdentifier context:self.context success:^(OPPaymentProductNetworks *paymentProductNetworks) {
            [self showApplePaySheetForPaymentProduct:paymentProduct withAvailableNetworks:paymentProductNetworks];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kOPAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"PaymentProductNetworksErrorExplanation", kOPAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)showApplePaySheetForPaymentProduct:(OPPaymentProduct *)paymentProduct withAvailableNetworks:(OPPaymentProductNetworks *)paymentProductNetworks {
    
    // This merchant should be the merchant id specified in the merchants developer portal.
    NSString *merchantId = [StandardUserDefaults objectForKey:kOPMerchantId];
    if (merchantId == nil) {
        return;
    }
    
    [self generateSummaryItems];
    
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    [paymentRequest setCountryCode:self.context.countryCode];
    [paymentRequest setCurrencyCode:self.context.amountOfMoney.currencyCode];
    [paymentRequest setSupportedNetworks:paymentProductNetworks.paymentProductNetworks];
    [paymentRequest setPaymentSummaryItems:self.summaryItems];
    
    // These capabilities should always be set to this value unless the merchant specifically does not want either Debit or Credit
    [paymentRequest setMerchantCapabilities:PKMerchantCapability3DS | PKMerchantCapabilityDebit | PKMerchantCapabilityCredit];
    
    // This merchant id is set in the merchants apple developer portal and is linked to a certificate
    [paymentRequest setMerchantIdentifier:merchantId];
    
    // These shipping and billing address fields are optional and can be chosen by the merchant
    [paymentRequest setRequiredShippingAddressFields: PKAddressFieldAll];
    [paymentRequest setRequiredBillingAddressFields:PKAddressFieldAll];
    
    self.authorizationViewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
    
    [self.authorizationViewController setDelegate:self];
    
    // The authorizationViewController will be nil if the paymentRequest was incomplete or not created correctly
    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:paymentProductNetworks.paymentProductNetworks] && self.authorizationViewController != nil) {
        self.applePayPaymentProduct = paymentProduct;
        [self.navigationController.topViewController presentViewController:self.authorizationViewController animated:YES completion:nil];
    }
}

- (void)generateSummaryItems {
    
    // ***************************************************************************
    //
    // The summaryItems for the paymentRequest is a list of values with the only
    // value being the subtotal. You are able to add more values to the list if
    // desired, like a shipping cost and total. ApplePay expects the last summary
    // item to be the grand total, this will be displayed differently from the
    // other summary items.
    //
    // The value is specified in cents and converted to a NSDecimalNumber with
    // a exponent of -2.
    //
    // ***************************************************************************
    
    long subtotal = self.context.amountOfMoney.totalAmount;
    
    NSMutableArray *summaryItems = [[NSMutableArray alloc] init];
    [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.subtotal", kOPSDKLocalizable, self.sdkBundle, @"subtotal summary item title") amount:[NSDecimalNumber decimalNumberWithMantissa:subtotal exponent:-2 isNegative:NO]]];
    
    self.summaryItems = summaryItems;
}

#pragma mark - Payment request target;

- (void)didSubmitPaymentRequest:(OPPaymentRequest *)paymentRequest {
    [self didSubmitPaymentRequest:paymentRequest success:nil failure:nil];
}

- (void)didSubmitPaymentRequest:(OPPaymentRequest *)paymentRequest success:(void (^)(void))succes failure:(void (^)(void))failure {
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"gc.app.general.loading.body", kOPSDKLocalizable, [NSBundle bundleWithPath:kOPSDKBundlePath], nil)];
    [self.session preparePaymentRequest:paymentRequest success:^(OPPreparedPaymentRequest *preparedPaymentRequest) {
        [SVProgressHUD dismiss];
        
        // ***************************************************************************
        //
        // The information contained in `preparedPaymentRequest.encryptedFields` should
        // be provided via the S2S Create Payment API, using field `encryptedCustomerInput`.
        //
        // ***************************************************************************
        
        [self.paymentFinishedTarget didFinishPayment];
        
        if (succes != nil) {
            succes();
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kOPAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"SubmitErrorExplanation", kOPAppLocalizable, nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        if (failure != nil) {
            failure();
        }
    }];
}

- (void)didCancelPaymentRequest {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate


// Sent to the delegate after the user has acted on the payment request.  The application
// should inspect the payment to determine whether the payment request was authorized.
//
// If the application requested a shipping address then the full addresses is now part of the payment.
//
// The delegate must call completion with an appropriate authorization status, as may be determined
// by submitting the payment credential to a processing gateway for payment authorization.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        OPPaymentRequest *request = [[OPPaymentRequest alloc] init];
        request.paymentProduct = self.applePayPaymentProduct;
        request.tokenize = NO;
        [request setValue:[[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding] forField:@"encryptedPaymentData"];
        [request setValue:payment.token.transactionIdentifier forField:@"transactionId"];
        [self didSubmitPaymentRequest:request success:^{
            completion(PKPaymentAuthorizationStatusSuccess);
        } failure:^{
            completion(PKPaymentAuthorizationStatusFailure);
        }];
        
        
    });
}


// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    self.applePayPaymentProduct = nil;
    [self.authorizationViewController dismissViewControllerAnimated:YES completion:nil];
}


// Sent when the user has selected a new payment card.  Use this delegate callback if you need to
// update the summary items in response to the card type changing (for example, applying credit card surcharges)
//
// The delegate will receive no further callbacks except paymentAuthorizationViewControllerDidFinish:
// until it has invoked the completion block.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                    didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod
                                completion:(void (^)(NSArray<PKPaymentSummaryItem *> *summaryItems))completion NS_AVAILABLE_IOS(9_0) {
    completion(self.summaryItems);
}

@end
