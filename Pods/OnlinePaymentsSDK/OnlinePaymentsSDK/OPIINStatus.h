//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef OnlinePaymentsSDKExample_OPIINStatus_h
#define OnlinePaymentsSDKExample_OPIINStatus_h

typedef enum {
    OPSupported,
    OPUnsupported,
    OPUnknown,
    OPNotEnoughDigits,
    OPPending,
    OPExistingButNotAllowed
} OPIINStatus;

#endif
