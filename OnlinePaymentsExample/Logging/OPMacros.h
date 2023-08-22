//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 17/05/2023
// Copyright © 2023 Global Collect Services. All rights reserved.
//

//Debug log
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
