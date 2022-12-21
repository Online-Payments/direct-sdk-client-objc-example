//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPAppConstants.h"
#import "OPPaymentProductsViewController.h"
#import "OPPaymentProductTableViewCell.h"
#import "OPPaymentProductsTableSection.h"
#import "OPPaymentProductsTableRow.h"
#import "OPTableSectionConverter.h"
#import "OPSummaryTableHeaderView.h"
#import "OPMerchantLogoImageView.h"

@import OnlinePaymentsKit;

@interface OPPaymentProductsViewController ()

@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) OPSummaryTableHeaderView *header;
@property (strong, nonatomic) NSBundle *sdkBundle;

@end

@implementation OPPaymentProductsViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sdkBundle = [NSBundle bundleWithPath:OPSDKConstants.kOPSDKBundlePath];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = [[OPMerchantLogoImageView alloc] init];

    [self initializeHeader];
    
    self.sections = [[NSMutableArray alloc] init];
    //TODO: Accounts on file
    if ([self.paymentItems hasAccountsOnFile] == YES) {
        OPPaymentProductsTableSection *accountsSection =
        [OPTableSectionConverter paymentProductsTableSectionFromAccountsOnFile:[self.paymentItems accountsOnFile] paymentItems:self.paymentItems];
        accountsSection.title = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductSelection.accountsOnFileTitle", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"Title of the section that displays stored payment products.");
        [self.sections addObject:accountsSection];
    }
    OPPaymentProductsTableSection *productsSection = [OPTableSectionConverter paymentProductsTableSectionFromPaymentItems:self.paymentItems];
    productsSection.title = NSLocalizedStringFromTableInBundle(@"gc.app.paymentProductSelection.pageTitle", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"Title of the section that shows all available payment products.");
    [self.sections addObject:productsSection];
    
    [self.tableView registerClass:[OPPaymentProductTableViewCell class] forCellReuseIdentifier:[OPPaymentProductTableViewCell reuseIdentifier]];
}

- (void)initializeHeader {
    self.header = (OPSummaryTableHeaderView *)[self.viewFactory tableHeaderViewWithType:OPSummaryTableHeaderViewType frame:CGRectMake(0, 0, self.tableView.frame.size.width, 70)];
    self.header.summary = [NSString stringWithFormat:@"%@:", NSLocalizedStringFromTableInBundle(@"gc.app.general.shoppingCart.total", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"Description of the amount header.")];
    NSNumber *amountAsNumber = [[NSNumber alloc] initWithFloat:self.amount / 100.0];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:self.currencyCode];
    NSString *amountAsString = [numberFormatter stringFromNumber:amountAsNumber];
    self.header.amount = amountAsString;
    self.header.securePayment = NSLocalizedStringFromTableInBundle(@"gc.app.general.securePaymentText", OPSDKConstants.kOPSDKLocalizable, self.sdkBundle, @"Text indicating that a secure payment method is used.");
    self.tableView.tableHeaderView = self.header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OPPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.rows.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    OPPaymentProductsTableSection *tableSection = self.sections[section];
    return tableSection.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OPPaymentProductTableViewCell *cell = (OPPaymentProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[OPPaymentProductTableViewCell reuseIdentifier]];
    
    OPPaymentProductsTableSection *section = self.sections[indexPath.section];
    OPPaymentProductsTableRow *row = section.rows[indexPath.row];
    cell.name = row.name;
    cell.logo = row.logo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OPPaymentProductsTableSection *section = self.sections[indexPath.section];
    OPPaymentProductsTableRow *row = section.rows[indexPath.row];
    NSObject<OPBasicPaymentItem> *paymentItem = [self.paymentItems paymentItemWithIdentifier:row.paymentProductIdentifier];
    if (section.type == OPAccountOnFileType) {
        OPBasicPaymentProduct *product = (OPBasicPaymentProduct *) paymentItem;
        OPAccountOnFile *accountOnFile = [product accountOnFileWithIdentifier:row.accountOnFileIdentifier];
        [self.target didSelectPaymentItem:product accountOnFile:accountOnFile];
    }
    else {
        [self.target didSelectPaymentItem:paymentItem accountOnFile:nil];
    }
}

@end
