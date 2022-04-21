// Based on the work of AFNetworking
//
// Copyright (c) 2018 AFNetworking (http://afnetworking.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OPNetworkingActivityLogger.h"
#import "OPNetworkingActivityConsoleLogger.h"
#import "OPNetworkingWrapper.h"
#import <objc/runtime.h>

static NSError * OPNetworkingErrorFromNotification(NSNotification *notification) {
    NSError *error = nil;
    if ([[notification object] isKindOfClass:[NSURLSessionTask class]]) {
        error = [(NSURLSessionTask *)[notification object] error];
        if (!error) {
            error = notification.userInfo[OPNetworkingTaskDidCompleteErrorKey];
        }
    }
    return error;
}

@interface OPNetworkingActivityLogger ()
@property (nonatomic, strong) NSMutableSet *mutableLoggers;

@end

@implementation OPNetworkingActivityLogger

+ (instancetype)sharedLogger {
    static OPNetworkingActivityLogger *_sharedLogger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLogger = [[self alloc] init];
    });
    
    return _sharedLogger;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.mutableLoggers = [NSMutableSet set];
    
    OPNetworkingActivityConsoleLogger *consoleLogger = [OPNetworkingActivityConsoleLogger new];
    [self addLogger:consoleLogger];
    
    return self;
}

- (NSSet *)loggers {
    return self.mutableLoggers;
}

- (void)dealloc {
    [self stopLogging];
}

- (void)addLogger:(id<OPNetworkingActivityLoggerProtocol>)logger {
    [self.mutableLoggers addObject:logger];
}

- (void)removeLogger:(id<OPNetworkingActivityLoggerProtocol>)logger {
    [self.mutableLoggers removeObject:logger];
}

- (void)setLogLevel:(OPHTTPRequestLoggerLevel)level {
    for (id<OPNetworkingActivityLoggerProtocol>logger in self.loggers) {
        logger.level = level;
    }
}

- (void)startLogging {
    [self stopLogging];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:OPNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:OPNetworkingTaskDidCompleteNotification object:nil];
}

- (void)stopLogging {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification

static void * OPNetworkingRequestStartDate = &OPNetworkingRequestStartDate;

- (void)networkRequestDidStart:(NSNotification *)notification {
    NSURLSessionTask *task = [notification object];
    NSURLRequest *request = task.originalRequest;
    
    if (!request) {
        return;
    }
    
    objc_setAssociatedObject(notification.object, OPNetworkingRequestStartDate, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    for (id <OPNetworkingActivityLoggerProtocol> logger in self.loggers) {
        if (request && logger.filterPredicate && [logger.filterPredicate evaluateWithObject:request]) {
            return;
        }
        
        [logger URLSessionTaskDidStart:task];
    }
}

- (void)networkRequestDidFinish:(NSNotification *)notification {
    NSURLSessionTask *task = [notification object];
    NSURLRequest *request = task.originalRequest;
    NSURLResponse *response = task.response;
    NSError *error = OPNetworkingErrorFromNotification(notification);
    
    if (!request && !response) {
        return;
    }
    
    id responseObject = nil;
    if (notification.userInfo) {
        responseObject = notification.userInfo[OPNetworkingTaskDidCompleteSerializedResponseKey];
    }
    
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(notification.object, OPNetworkingRequestStartDate)];
    
    for (id <OPNetworkingActivityLoggerProtocol> logger in self.loggers) {
        if (request && logger.filterPredicate && [logger.filterPredicate evaluateWithObject:request]) {
            return;
        }
        
        [logger URLSessionTaskDidFinish:task withResponseObject:responseObject inElapsedTime:elapsedTime withError:error];
    }
}

@end
