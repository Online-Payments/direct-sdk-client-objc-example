//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <PassKit/PassKit.h>

#import "OPPaymentProductSelectionTarget.h"
#import "OPPaymentRequestTarget.h"
#import "OPContinueShoppingTarget.h"
#import "OPPaymentFinishedTarget.h"

@interface OPStartViewController : UIViewController <OPContinueShoppingTarget, OPPaymentFinishedTarget>

@end
