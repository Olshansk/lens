//
//  NSURL+Parameters.m
//  ProjectOak
//
//  Created by Daniel Olshansky on 2013-01-05.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "NSURL+Parameters.h"

#define ADD_PARAMETER_TEXT_FIRST @"%@=%@"
#define ADD_PARAMETER_TEXT_FIRST_ARRAY @"%@[]=%@"
#define ADD_PARAMETER_TEXT @"&%@=%@"
#define ADD_PARAMETER_TEXT_ARRAY @"&%@[]=%@"

@implementation NSURL (Parameters)

+ (id)URLWithRoot:(NSString *)root withParameters:(NSDictionary*)params
{
    BOOL first = YES;
    NSMutableString *str = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@?",root]];
    for (NSString *key in [params keyEnumerator]) {
        if (first) {
            first = NO;
            [str appendString:[NSString stringWithFormat:ADD_PARAMETER_TEXT_FIRST, key, [params objectForKey:key]]];
        } else {
            [str appendString:[NSString stringWithFormat:ADD_PARAMETER_TEXT, key, [params objectForKey:key]]];
        }
    }
    return [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
}

+ (NSString*)PostDataWithParameters:(NSDictionary*)params
{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    BOOL first = YES;
    for (NSString *key in [params keyEnumerator]) {
        if (first) {
            if ([[params objectForKey:key] isKindOfClass:[NSArray class]]) {
                for (NSString *temp in [params objectForKey:key]) {
                    if (first) {
                        [str appendString:[NSString stringWithFormat:ADD_PARAMETER_TEXT_FIRST_ARRAY, key, temp]];
                        first = NO;
                    } else {
                        [str appendString:[NSString stringWithFormat:ADD_PARAMETER_TEXT_ARRAY, key, temp]];
                    }
                }
            } else {
                [str appendString:[NSString stringWithFormat:ADD_PARAMETER_TEXT_FIRST, key, [params objectForKey:key]]];
                first = NO;
            }
        } else {
            if ([[params objectForKey:key] isKindOfClass:[NSArray class]]) {
                for (NSString *temp in [params objectForKey:key]) {
                    [str appendString:[NSString stringWithFormat:ADD_PARAMETER_TEXT_ARRAY, key, temp]];
                }
            } else {
                [str appendString:[NSString stringWithFormat:ADD_PARAMETER_TEXT, key, [params objectForKey:key]]];
            }
        }
    }
    return str;
}

@end