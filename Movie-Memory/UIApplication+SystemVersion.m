//
//  UIApplication+SystemVersion.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/19/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "UIApplication+SystemVersion.h"

@implementation UIApplication (SystemVersion)

+ (BOOL)isIOS8 {
    
    static BOOL IOS8;
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    if ([version isEqualToString:@"8.0"] || [version isEqualToString:@"8.1"]) {
        IOS8 = YES;
    } else {
        return NO;
    }
    
    return IOS8;
}

@end
