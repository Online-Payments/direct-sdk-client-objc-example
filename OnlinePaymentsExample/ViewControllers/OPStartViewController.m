//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "OPAppConstants.h"
#import "OPStartViewController.h"
#import "OPViewFactory.h"
#import "OPPaymentProductsViewController.h"
#import "OPPaymentProductViewController.h"
#import "OPEndViewController.h"
#import "OPPaymentProductsViewControllerTarget.h"

@import OnlinePaymentsKit;

@interface OPStartViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UITextView *explanation;
@property (strong, nonatomic) OPLabel *clientSessionIdLabel;
@property (strong, nonatomic) OPTextField *clientSessionOPTextField;
@property (strong, nonatomic) OPLabel *customerIdLabel;
@property (strong, nonatomic) OPTextField *customerOPTextField;
@property (strong, nonatomic) OPLabel *baseURLLabel;
@property (strong, nonatomic) OPTextField *baseURLTextField;
@property (strong, nonatomic) OPLabel *assetsBaseURLLabel;
@property (strong, nonatomic) OPTextField *assetsBaseURLTextField;
@property (strong, nonatomic) OPLabel *merchantIdLabel;
@property (strong, nonatomic) OPTextField *merchantOPTextField;
@property (strong, nonatomic) OPLabel *amountLabel;
@property (strong, nonatomic) OPTextField *amountTextField;
@property (strong, nonatomic) OPLabel *countryCodeLabel;
@property (strong, nonatomic) OPTextField *countryCodeTextField;
@property (strong, nonatomic) OPLabel *currencyCodeLabel;
@property (strong, nonatomic) OPTextField *currencyCodeTextField;
@property (strong, nonatomic) OPLabel *isRecurringLabel;
@property (strong, nonatomic) OPSwitch *isRecurringSwitch;
@property (strong, nonatomic) UIButton *payButton;
@property (strong, nonatomic) OPPaymentProductsViewControllerTarget *paymentProductsViewControllerTarget;

@property (nonatomic) long amountValue;

@property (strong, nonatomic) OPViewFactory *viewFactory;
@property (strong, nonatomic) OPSession *session;
@property (strong, nonatomic) OPPaymentContext *context;

@end

@implementation OPStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTapRecognizer];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] == YES) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.viewFactory = [[OPViewFactory alloc] init];

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
    
    UIView *superContainerView = [[UIView alloc] init];
    superContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    superContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:superContainerView];
    
    self.containerView = [[UIView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [superContainerView addSubview:self.containerView];


    self.explanation = [[UITextView alloc] init];
    self.explanation.translatesAutoresizingMaskIntoConstraints = NO;
    self.explanation.text = NSLocalizedStringFromTable(@"SetupExplanation", kOPAppLocalizable, @"To process a payment using the services provided by the Online Payments platform, the following information must be provided by a merchant.\n\nAfter providing the information requested below, this example app can process a payment.");
    self.explanation.editable = NO;
    self.explanation.backgroundColor = [UIColor colorWithRed:0.85 green:0.94 blue:0.97 alpha:1];
    self.explanation.textColor = [UIColor colorWithRed:0 green:0.58 blue:0.82 alpha:1];
    self.explanation.layer.cornerRadius = 5.0;
    self.explanation.scrollEnabled = NO;
    [self.containerView addSubview:self.explanation];

    self.clientSessionIdLabel = [self.viewFactory labelWithType:OPLabelType];
    self.clientSessionIdLabel.text = NSLocalizedStringFromTable(@"ClientSessionIdentifier", kOPAppLocalizable, @"Client session identifier");
    self.clientSessionIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionOPTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.clientSessionOPTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.clientSessionOPTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.clientSessionOPTextField.text = [OPSDKConstants.StandardUserDefaults objectForKey:kOPClientSessionId];
    [self.containerView addSubview:self.clientSessionIdLabel];
    [self.containerView addSubview:self.clientSessionOPTextField];
    
    self.customerIdLabel = [self.viewFactory labelWithType:OPLabelType];
    self.customerIdLabel.text = NSLocalizedStringFromTable(@"CustomerIdentifier", kOPAppLocalizable, @"Customer identifier");
    self.customerIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerOPTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.customerOPTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.customerOPTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.customerOPTextField.text = [OPSDKConstants.StandardUserDefaults objectForKey:kOPCustomerId];
    [self.containerView addSubview:self.customerIdLabel];
    [self.containerView addSubview:self.customerOPTextField];
    
    self.baseURLLabel = [self.viewFactory labelWithType:OPLabelType];
    self.baseURLLabel.text = NSLocalizedStringFromTable(@"BaseURL", kOPAppLocalizable, @"Base URL");
    self.baseURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseURLTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.baseURLTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.baseURLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.baseURLTextField.text = [OPSDKConstants.StandardUserDefaults objectForKey:kOPBaseURL];
    [self.containerView addSubview:self.baseURLLabel];
    [self.containerView addSubview:self.baseURLTextField];
    
    self.assetsBaseURLLabel = [self.viewFactory labelWithType:OPLabelType];
    self.assetsBaseURLLabel.text = NSLocalizedStringFromTable(@"AssetsBaseURL", kOPAppLocalizable, @"Assets Base URL");
    self.assetsBaseURLLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.assetsBaseURLTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.assetsBaseURLTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.assetsBaseURLTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.assetsBaseURLTextField.text = [OPSDKConstants.StandardUserDefaults objectForKey:kOPAssetsBaseURL];
    [self.containerView addSubview:self.assetsBaseURLLabel];
    [self.containerView addSubview:self.assetsBaseURLTextField];

    self.merchantIdLabel = [self.viewFactory labelWithType:OPLabelType];
    self.merchantIdLabel.text = NSLocalizedStringFromTable(@"MerchantIdentifier", kOPAppLocalizable, @"Merchant identifier");
    self.merchantIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.merchantOPTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.merchantOPTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.merchantOPTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.merchantOPTextField.text = [OPSDKConstants.StandardUserDefaults objectForKey:kOPMerchantId];
    [self.containerView addSubview:self.merchantIdLabel];
    [self.containerView addSubview:self.merchantOPTextField];
    
    self.amountLabel = [self.viewFactory labelWithType:OPLabelType];
    self.amountLabel.text = NSLocalizedStringFromTable(@"AmountInCents", kOPAppLocalizable, @"Amount in cents");
    self.amountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.amountTextField.translatesAutoresizingMaskIntoConstraints = NO;
    NSInteger amount = [[NSUserDefaults standardUserDefaults] integerForKey:kOPPrice];
    if (amount == 0) {
        self.amountTextField.text = @"100";
    }
    else {
        self.amountTextField.text = [NSString stringWithFormat:@"%ld", (long)amount];

    }
    [self.containerView addSubview:self.amountLabel];
    [self.containerView addSubview:self.amountTextField];
    
    self.countryCodeLabel = [self.viewFactory labelWithType:OPLabelType];
    self.countryCodeLabel.text = NSLocalizedStringFromTable(@"CountryCode", kOPAppLocalizable, @"Country code");
    self.countryCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodeTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.countryCodeTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.countryCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.countryCodeTextField.text = [OPSDKConstants.StandardUserDefaults objectForKey:kOPCountryCode];
    [self.containerView addSubview:self.countryCodeLabel];
    [self.containerView addSubview:self.countryCodeTextField];
    
    self.currencyCodeLabel = [self.viewFactory labelWithType:OPLabelType];
    self.currencyCodeLabel.text = NSLocalizedStringFromTable(@"CurrencyCode", kOPAppLocalizable, @"Currency code");
    self.currencyCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodeTextField = [self.viewFactory textFieldWithType:OPTextFieldType];
    self.currencyCodeTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.currencyCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.currencyCodeTextField.text = [OPSDKConstants.StandardUserDefaults objectForKey:kOPCurrency];
    [self.containerView addSubview:self.currencyCodeLabel];
    [self.containerView addSubview:self.currencyCodeTextField];
    
    self.isRecurringLabel = [self.viewFactory labelWithType:OPLabelType];
    self.isRecurringLabel.text = NSLocalizedStringFromTable(@"RecurringPayment", kOPAppLocalizable, @"Payment is recurring");
    self.isRecurringLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.isRecurringSwitch = [self.viewFactory switchWithType:OPSwitchType];
    self.isRecurringSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.isRecurringLabel];
    [self.containerView addSubview:self.isRecurringSwitch];

    self.payButton = [self.viewFactory buttonWithType:OPButtonTypePrimary];
    [self.payButton setTitle:NSLocalizedStringFromTable(@"PayNow", kOPAppLocalizable, @"Pay securely now") forState:UIControlStateNormal];
    self.payButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.payButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.payButton];

    NSDictionary *views = NSDictionaryOfVariableBindings(_explanation, _clientSessionIdLabel, _clientSessionOPTextField, _customerIdLabel, _customerOPTextField, _baseURLLabel, _baseURLTextField, _assetsBaseURLLabel, _assetsBaseURLTextField, _merchantIdLabel, _merchantOPTextField, _amountLabel, _amountTextField, _countryCodeLabel, _countryCodeTextField, _currencyCodeLabel, _currencyCodeTextField, _isRecurringLabel, _isRecurringSwitch, _payButton, _containerView, _scrollView, superContainerView);
    NSDictionary *metrics = @{@"fieldSeparator": @"24", @"groupSeparator": @"72"};

    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_explanation]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_clientSessionOPTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_customerOPTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baseURLLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_baseURLTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_assetsBaseURLLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_assetsBaseURLTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_merchantIdLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_merchantOPTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_amountTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_countryCodeTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodeLabel]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currencyCodeTextField]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_isRecurringLabel]-[_isRecurringSwitch]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_payButton]-|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_explanation]-(fieldSeparator)-[_clientSessionIdLabel]-[_clientSessionOPTextField]-(fieldSeparator)-[_customerIdLabel]-[_customerOPTextField]-(fieldSeparator)-[_baseURLLabel]-[_baseURLTextField]-(fieldSeparator)-[_assetsBaseURLLabel]-[_assetsBaseURLTextField]-(fieldSeparator)-[_merchantIdLabel]-[_merchantOPTextField]-(groupSeparator)-[_amountLabel]-[_amountTextField]-(fieldSeparator)-[_countryCodeLabel]-[_countryCodeTextField]-(fieldSeparator)-[_currencyCodeLabel]-[_currencyCodeTextField]-(fieldSeparator)-[_isRecurringSwitch]-(fieldSeparator)-[_payButton]-|" options:0 metrics:metrics views:views]];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    superContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:superContainerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0], [NSLayoutConstraint constraintWithItem:superContainerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[superContainerView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[superContainerView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:0 metrics:nil views:views]];
    [superContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_containerView]|" options:0 metrics:nil views:views]];
    [superContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:320]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)initializeTapRecognizer {
    UITapGestureRecognizer *tapScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)];
    tapScrollView.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapScrollView];
}

- (void)tableViewTapped {
    for (UIView *view in self.containerView.subviews) {
        if ([view class] == [OPTextField class]) {
            OPTextField *textField = (OPTextField *)view;
            if ([textField isFirstResponder] == YES) {
                [textField resignFirstResponder];
            }
        }
    }
}

#pragma mark - Picker view delegate

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

- (BOOL)checkURL:(NSString *)url {
    NSMutableArray<NSString *> *components;
    if (@available(iOS 7.0, *)) {
        NSURLComponents *finalComponents = [NSURLComponents componentsWithString:url];
        components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    else {
        components = [[[NSURL URLWithString:url].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                      [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
    }
    
    
    NSArray<NSString *> *versionComponents = [OPSDKConstants.kOPAPIVersion componentsSeparatedByString:@"/"];
    switch (components.count) {
        case 0: {
            components = versionComponents.mutableCopy;
            break;
        }
        case 1: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                return NO;
            }
            [components addObject:versionComponents[1]];
            break;
        }
        case 2: {
            if (![components[0] isEqualToString:versionComponents[0]]) {
                return NO;
            }
            if (![components[1] isEqualToString:versionComponents[1]]) {
                return NO;
            }
            break;
        }
        default: {
            return NO;
            break;
        }
    }
    return YES;
}

#pragma mark - Button actions

- (void)buyButtonTapped:(UIButton *)sender {
    if (self.payButton == sender) {
        self.amountValue = (long) [self.amountTextField.text longLongValue];
    } else {
        [NSException raise:@"Invalid sender" format:@"Sender %@ is invalid", sender];
    }

    [SVProgressHUD showWithStatus:NSLocalizedStringFromTableInBundle(@"gc.app.general.loading.body", OPSDKConstants.kOPSDKLocalizable, [NSBundle bundleWithPath:OPSDKConstants.kOPSDKBundlePath], nil)];

    NSString *clientSessionId = self.clientSessionOPTextField.text;
    [OPSDKConstants.StandardUserDefaults setObject:clientSessionId forKey:kOPClientSessionId];
    NSString *customerId = self.customerOPTextField.text;
    [OPSDKConstants.StandardUserDefaults setObject:customerId forKey:kOPCustomerId];
    NSString *baseURL = self.baseURLTextField.text;
    [OPSDKConstants.StandardUserDefaults setObject:baseURL forKey:kOPBaseURL];
    NSString *assetsBaseURL = self.assetsBaseURLTextField.text;
    [OPSDKConstants.StandardUserDefaults setObject:assetsBaseURL forKey:kOPAssetsBaseURL];

    if (self.merchantOPTextField.text != nil) {
        NSString *merchantId = self.merchantOPTextField.text;
        [OPSDKConstants.StandardUserDefaults setObject:merchantId forKey:kOPMerchantId];
    }
    [OPSDKConstants.StandardUserDefaults setInteger:self.amountValue forKey:kOPPrice];
    NSString *countryCode = self.countryCodeTextField.text;
    [OPSDKConstants.StandardUserDefaults setObject:countryCode forKey:kOPCountryCode];
    NSString *currencyCode = self.currencyCodeTextField.text;
    [OPSDKConstants.StandardUserDefaults setObject:currencyCode forKey:kOPCurrency];

    // ***************************************************************************
    //
    // The Online Payments SDK supports processing payments with instances of the
    // OPSession class. The code below shows how such an instance could be
    // instantiated.
    //
    // The OPSession class uses a number of supporting objects. There is an
    // initializer for this class that takes these supporting objects as
    // arguments. This should make it easy to replace these additional objects
    // without changing the implementation of the SDK. Use this initializer
    // instead of the factory method used below if you want to replace any of the
    // supporting objects.
    //
    // ***************************************************************************
    if (![self checkURL:baseURL]) {
        [SVProgressHUD dismiss];
        NSMutableArray<NSString *> *components;
        if (@available(iOS 7.0, *)) {
            NSURLComponents *finalComponents = [NSURLComponents componentsWithString:baseURL];
            components = [[finalComponents.path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                          [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
        }
        else {
            components = [[[NSURL URLWithString:baseURL].path componentsSeparatedByString:@"/"] filteredArrayUsingPredicate:
                          [NSPredicate predicateWithFormat:@"length > 0"]].mutableCopy;
        }
        NSArray<NSString *> *versionComponents = [OPSDKConstants.kOPAPIVersion componentsSeparatedByString:@"/"];
        NSString *alertReason = [NSString stringWithFormat: @"This version of the Online Payments SDK is only compatible with %@ , you supplied: '%@'",
                                 [versionComponents componentsJoinedByString: @"/"],
                                 [components componentsJoinedByString: @"/"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"CompatibilityError", kOPAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(alertReason, kOPAppLocalizable, nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    self.session = [OPSession sessionWithClientSessionId:clientSessionId customerId:customerId baseURL:baseURL assetBaseURL:assetsBaseURL appIdentifier:kOPApplicationIdentifier];

    BOOL isRecurring = self.isRecurringSwitch.on;

    // ***************************************************************************
    //
    // To retrieve the available payment products, the information stored in the
    // following OPPaymentContext object is needed.
    //
    // After the OPSession object has retrieved the payment products that match
    // the information stored in the OPPaymentContext object, a
    // selection screen is shown. This screen itself is not part of the SDK and
    // only illustrates a possible payment product selection screen.
    //
    // ***************************************************************************
    OPPaymentAmountOfMoney *amountOfMoney = [[OPPaymentAmountOfMoney alloc] initWithTotalAmount:self.amountValue currencyCode:currencyCode];
    self.context = [[OPPaymentContext alloc] initWithAmountOfMoney:amountOfMoney isRecurring:isRecurring countryCode:countryCode];

    [self.session paymentItemsForContext:self.context groupPaymentProducts:NO success:^(OPPaymentItems *paymentItems) {
        if (paymentItems.paymentItems.count != 0) {
            [SVProgressHUD dismiss];
            [self showPaymentProductSelection:paymentItems];
        } else {
            [SVProgressHUD dismiss];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"PaymentFailureTitle", kOPAppLocalizable, @"Title of the payment failure dialog.") message:NSLocalizedStringFromTable(@"TechnicalProblemErrorExplanation", kOPAppLocalizable, @"Message of the payment failure dialog.") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"ConnectionErrorTitle", kOPAppLocalizable, @"Title of the connection error dialog.") message:NSLocalizedStringFromTable(@"PaymentProductsErrorExplanation", kOPAppLocalizable, @"Message of the connection error dialog.") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)showPaymentProductSelection:(OPPaymentItems *)paymentItems {
    self.paymentProductsViewControllerTarget = [[OPPaymentProductsViewControllerTarget alloc] initWithNavigationController:self.navigationController session:self.session context:self.context viewFactory:self.viewFactory];
    self.paymentProductsViewControllerTarget.paymentFinishedTarget = self;
    OPPaymentProductsViewController *paymentProductSelection = [[OPPaymentProductsViewController alloc] init];
    paymentProductSelection.target = self.paymentProductsViewControllerTarget;
    paymentProductSelection.paymentItems = paymentItems;
    paymentProductSelection.viewFactory = self.viewFactory;
    paymentProductSelection.amount = self.amountValue;
    paymentProductSelection.currencyCode = self.context.amountOfMoney.currencyCodeString;
    [self.navigationController pushViewController:paymentProductSelection animated:YES];
    [SVProgressHUD dismiss];
}

#pragma mark - Continue shopping target

- (void)didSelectContinueShopping {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Payment finished target

- (void)didFinishPayment {
    OPEndViewController *end = [[OPEndViewController alloc] init];
    end.target = self;
    end.viewFactory = self.viewFactory;
    [self.navigationController pushViewController:end animated:YES];
}

@end
