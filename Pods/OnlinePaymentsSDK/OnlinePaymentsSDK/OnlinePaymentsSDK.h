//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#import <UIKit/UIKit.h>

//! Project version number for OnlinePaymentsSDK.
FOUNDATION_EXPORT double OnlinePaymentsSDKVersionNumber;

//! Project version string for OnlinePaymentsSDK.
FOUNDATION_EXPORT const unsigned char OnlinePaymentsSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <OnlinePaymentsSDK/PublicHeader.h>

#import <OnlinePaymentsSDK/OPAssetManager.h>
#import <OnlinePaymentsSDK/OPC2SCommunicator.h>
#import <OnlinePaymentsSDK/OPC2SCommunicatorConfiguration.h>
#import <OnlinePaymentsSDK/OPSession.h>
#import <OnlinePaymentsSDK/OPUtil.h>

#import <OnlinePaymentsSDK/OPBase64.h>

#import <OnlinePaymentsSDK/OPSDKConstants.h>

#import <OnlinePaymentsSDK/OPBasicPaymentItemConverter.h>
#import <OnlinePaymentsSDK/OPBasicPaymentProductConverter.h>
#import <OnlinePaymentsSDK/OPBasicPaymentProductsConverter.h>
#import <OnlinePaymentsSDK/OPIINDetailsResponseConverter.h>
#import <OnlinePaymentsSDK/OPPaymentContextConverter.h>
#import <OnlinePaymentsSDK/OPPaymentItemConverter.h>
#import <OnlinePaymentsSDK/OPPaymentProductConverter.h>

#import <OnlinePaymentsSDK/OPEncryptor.h>
#import <OnlinePaymentsSDK/OPJOSEEncryptor.h>

#import <OnlinePaymentsSDK/OPAccountOnFileAttributeStatus.h>
#import <OnlinePaymentsSDK/OPFormElementType.h>
#import <OnlinePaymentsSDK/OPIINStatus.h>
#import <OnlinePaymentsSDK/OPPreferredInputType.h>
#import <OnlinePaymentsSDK/OPType.h>

#import <OnlinePaymentsSDK/OPStringFormatter.h>

#import <OnlinePaymentsSDK/OPJSON.h>

#import <OnlinePaymentsSDK/OPMacros.h>

#import <OnlinePaymentsSDK/OPAccountOnFile.h>
#import <OnlinePaymentsSDK/OPAccountOnFileAttribute.h>
#import <OnlinePaymentsSDK/OPAccountOnFileAttributes.h>
#import <OnlinePaymentsSDK/OPAccountOnFileDisplayHints.h>
#import <OnlinePaymentsSDK/OPAccountsOnFile.h>

#import <OnlinePaymentsSDK/OPPaymentContext.h>
#import <OnlinePaymentsSDK/OPPaymentAmountOfMoney.h>

#import <OnlinePaymentsSDK/OPIINDetailsResponse.h>
#import <OnlinePaymentsSDK/OPIINDetail.h>

#import <OnlinePaymentsSDK/OPBasicPaymentProduct.h>
#import <OnlinePaymentsSDK/OPBasicPaymentProducts.h>
#import <OnlinePaymentsSDK/OPDataRestrictions.h>
#import <OnlinePaymentsSDK/OPDisplayElement.h>
#import <OnlinePaymentsSDK/OPDisplayElementsConverter.h>
#import <OnlinePaymentsSDK/OPDisplayElementType.h>
#import <OnlinePaymentsSDK/OPFormElement.h>
#import <OnlinePaymentsSDK/OPLabelTemplate.h>
#import <OnlinePaymentsSDK/OPLabelTemplateItem.h>
#import <OnlinePaymentsSDK/OPPaymentItemDisplayHints.h>
#import <OnlinePaymentsSDK/OPPaymentItems.h>
#import <OnlinePaymentsSDK/OPPaymentProduct.h>
#import <OnlinePaymentsSDK/OPPaymentProduct302SpecificData.h>
#import <OnlinePaymentsSDK/OPPaymentProductField.h>
#import <OnlinePaymentsSDK/OPPaymentProductFieldDisplayHints.h>
#import <OnlinePaymentsSDK/OPPaymentProductFields.h>
#import <OnlinePaymentsSDK/OPPaymentProductNetworks.h>
#import <OnlinePaymentsSDK/OPTooltip.h>

#import <OnlinePaymentsSDK/OPPaymentRequest.h>
#import <OnlinePaymentsSDK/OPPreparedPaymentRequest.h>

#import <OnlinePaymentsSDK/OPPublicKeyResponse.h>

#import <OnlinePaymentsSDK/OPValidator.h>
#import <OnlinePaymentsSDK/OPValidatorEmailAddress.h>
#import <OnlinePaymentsSDK/OPValidatorExpirationDate.h>
#import <OnlinePaymentsSDK/OPValidatorFixedList.h>
#import <OnlinePaymentsSDK/OPValidatorIBAN.h>
#import <OnlinePaymentsSDK/OPValidatorLength.h>
#import <OnlinePaymentsSDK/OPValidatorLuhn.h>
#import <OnlinePaymentsSDK/OPValidatorRange.h>
#import <OnlinePaymentsSDK/OPValidatorRegularExpression.h>
#import <OnlinePaymentsSDK/OPValidators.h>
#import <OnlinePaymentsSDK/OPValidatorTermsAndConditions.h>
#import <OnlinePaymentsSDK/OPValueMappingItem.h>

#import <OnlinePaymentsSDK/OPValidationError.h>
#import <OnlinePaymentsSDK/OPValidationErrorAllowed.h>
#import <OnlinePaymentsSDK/OPValidationErrorEmailAddress.h>
#import <OnlinePaymentsSDK/OPValidationErrorExpirationDate.h>
#import <OnlinePaymentsSDK/OPValidationErrorFixedList.h>
#import <OnlinePaymentsSDK/OPValidationErrorIBAN.h>
#import <OnlinePaymentsSDK/OPValidationErrorInteger.h>
#import <OnlinePaymentsSDK/OPValidationErrorIsRequired.h>
#import <OnlinePaymentsSDK/OPValidationErrorLength.h>
#import <OnlinePaymentsSDK/OPValidationErrorLuhn.h>
#import <OnlinePaymentsSDK/OPValidationErrorNumericString.h>
#import <OnlinePaymentsSDK/OPValidationErrorRange.h>
#import <OnlinePaymentsSDK/OPValidationErrorRegularExpression.h>
#import <OnlinePaymentsSDK/OPValidationErrorTermsAndConditions.h>

#import <OnlinePaymentsSDK/OPBasicPaymentItem.h>
#import <OnlinePaymentsSDK/OPPaymentItem.h>

#import <OnlinePaymentsSDK/OPAFNetworkingWrapper.h>
#import <OnlinePaymentsSDK/OPNetworkingWrapper.h>
