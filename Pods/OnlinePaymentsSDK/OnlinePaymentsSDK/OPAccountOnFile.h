//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPAccountOnFileAttributes.h"
#import "OPAccountOnFileDisplayHints.h"
#import "OPStringFormatter.h"

@interface OPAccountOnFile : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *paymentProductIdentifier;
@property (strong, nonatomic) OPAccountOnFileDisplayHints *displayHints;
@property (strong, nonatomic) OPAccountOnFileAttributes *attributes;

- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId;
- (NSString *)maskedValueForField:(NSString *)paymentProductFieldId mask:(NSString *)mask;
- (BOOL)hasValueForField:(NSString *)paymentProductFieldId;
- (BOOL)fieldIsReadOnly:(NSString *)paymentProductFieldId;
- (NSString *)label;
- (void)setStringFormatter:(OPStringFormatter *)stringFormatter;

@end
