//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPPaymentProductSelectionTarget.h"
#import "OPViewFactory.h"

#import <OnlinePaymentsSDK/OPBasicPaymentProducts.h>

@class OPPaymentItems;

@interface OPPaymentProductsViewController : UITableViewController

@property (strong, nonatomic) OPViewFactory *viewFactory;
@property (weak, nonatomic) id <OPPaymentProductSelectionTarget> target;
@property (strong, nonatomic) OPPaymentItems *paymentItems;
@property (nonatomic) NSInteger amount;
@property (strong, nonatomic) NSString *currencyCode;

@end
