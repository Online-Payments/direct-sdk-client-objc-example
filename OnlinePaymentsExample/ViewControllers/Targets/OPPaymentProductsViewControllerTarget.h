//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <PassKit/PassKit.h>

#import "OPPaymentProductSelectionTarget.h"
#import "OPPaymentRequestTarget.h"
#import "OPPaymentFinishedTarget.h"
#import "OPSession.h"
#import "OPViewFactory.h"

@interface OPPaymentProductsViewControllerTarget : NSObject <OPPaymentProductSelectionTarget, OPPaymentRequestTarget, PKPaymentAuthorizationViewControllerDelegate>

@property (weak, nonatomic) id <OPPaymentFinishedTarget> paymentFinishedTarget;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController session:(OPSession *)session context:(OPPaymentContext *)context viewFactory:(OPViewFactory *)viewFactory;
- (void)didSubmitPaymentRequest:(OPPaymentRequest *)paymentRequest success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)showApplePaySheetForPaymentProduct:(OPPaymentProduct *)paymentProduct withAvailableNetworks:(OPPaymentProductNetworks *)paymentProductNetworks;

@end
