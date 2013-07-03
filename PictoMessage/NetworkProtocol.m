//
//  NetworkProtocol.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-08.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "NetworkProtocol.h"

#import "NSURL+Parameters.h"

#define ROOT @"http://107.22.142.146/"
#define TIME_OUT_INTERVAL 60

@implementation NetworkProtocol

+(void)post:(NSDictionary*)params to:(NSString*)point withSuccessBlock:(void (^)(NSDictionary*))successBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json",ROOT,point]];

    NSString *body = [NSURL PostDataWithParameters:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if (!response) {
            NSLog(@"Network Error: %@", error);
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        if (result) {
            successBlock(result);
        }
        else {
            NSLog(@"JSON Parsing Error: %@", jsonError);
        }
    }];
}


+(void)put:(NSDictionary *)params from:(NSString *)point withSuccessBlock:(void (^)(NSDictionary *))successBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.json",ROOT,point]];
    
    NSString *body = [NSURL PostDataWithParameters:params];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%d",body.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if (!response) {
            NSLog(@"Network Error: %@", error);
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        if (result) {
            successBlock(result);
        }
        else {
            NSLog(@"JSON Parsing Error: %@", jsonError);
        }
    }];
}

+(void)get:(NSDictionary*)params from:(NSString*)point withSuccessBlock:(void (^)(NSDictionary*))successBlock
{
    NSURL *url = [NSURL URLWithRoot:[NSString stringWithFormat:@"%@/%@.json",ROOT,point] withParameters:params];
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT_INTERVAL];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if (!response) {
            NSLog(@"Network Error: %@", error);
            return;
        }
        NSError *jsonError;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
        if (result) {
            successBlock(result);
        }
        else {
            NSLog(@"JSON Parsing Error: %@", jsonError);
        }
    }];
}

@end
