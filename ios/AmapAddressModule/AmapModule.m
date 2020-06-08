//
//  AmapModule.m
//
//  Created by jszh on 2020/06/08.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "AmapModule.h"

@implementation AmapModule

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
{
    // TODO: Implement some actually useful functionality
    callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
}

@end
