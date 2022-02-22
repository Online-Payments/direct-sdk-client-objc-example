//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPContinueShoppingTarget.h"
#import "OPViewFactory.h"

@interface OPEndViewController : UIViewController

@property (weak, nonatomic) id <OPContinueShoppingTarget> target;
@property (strong, nonatomic) OPViewFactory *viewFactory;

@end
