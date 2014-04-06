//
//  LQConstants.h
//  LiquidApp
//
//  Created by Liquid Data Intelligence, S.A. (lqd.io) on 3/28/14.
//  Copyright (c) 2014 Liquid Data Intelligence, S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

// Customizable options
#define kLQDefaultSessionTimeout @30 //seconds
#define kLQQueueSizeLimit 250 // datapoints
#ifdef DEBUG
#    define kLQDefaultFlushInterval @5 //seconds
#else
#    define kLQDefaultFlushInterval @10 //seconds
#endif
#define kLQMaxNumberOfTries 10
#define kLQDefaultFlushOnBackground YES
#define kLQDirectory kLQBundle
#define kLQValuesFileName @"LiquidVariables"
#define kLQSendBundleVariablesOnDebugMode YES

#define kLQLogLevel 3

// Liquid internal constants
#define kLQServerUrl @"http://api.lqd.io/collect/"
#define kLQVersion @"0.3.0"
#define kLQBundle @"com.liquid"
#define kLQLogLevelPaths     7
#define kLQLogLevelHttp      6
#define kLQLogLevelData      5
#define kLQLogLevelEvent     4
#define kLQLogLevelDataPoint 3
#define kLQLogLevelWarning   2
#define kLQLogLevelError     1

#ifdef DEBUG
#   define LQLog(level,...) if(level<=kLQLogLevel) NSLog(__VA_ARGS__)
#else
#   define LQLog(...)
#endif
