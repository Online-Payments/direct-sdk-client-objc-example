//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
//

#import "OPValidatorEmailAddress.h"
#import "OPValidationErrorEmailAddress.h"

@interface OPValidatorEmailAddress ()

@property (strong, nonatomic) NSRegularExpression *expression;

@end

@implementation OPValidatorEmailAddress

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        NSError *error = nil;
        NSString *regex = @"^[^@\\.]+(\\.[^@\\.]+)*@([^@\\.]+\\.)*[^@\\.]+\\.[^@\\.][^@\\.]+$";
        self.expression = [[NSRegularExpression alloc] initWithPattern:regex options:0 error:&error];
    }
    return self;
}

- (void)validate:(NSString *)value forPaymentRequest:(OPPaymentRequest *)request
{
    [super validate:value forPaymentRequest:request];
    NSInteger numberOfMatches = [self.expression numberOfMatchesInString:value options:0 range:NSMakeRange(0, value.length)];
    if (numberOfMatches != 1) {
        OPValidationErrorEmailAddress *error = [[OPValidationErrorEmailAddress alloc] init];
        [self.errors addObject:error];
    }
}

@end
