//
//  NetworkProtocol.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-08.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkProtocol : NSObject

+(void)post:(NSDictionary*)params to:(NSString*)point withSuccessBlock:(void (^)(NSDictionary*))successBlock;
+(void)get:(NSDictionary*)params from:(NSString*)point withSuccessBlock:(void (^)(NSDictionary*))successBlock;
+(void)put:(NSDictionary*)params from:(NSString*)point withSuccessBlock:(void (^)(NSDictionary*))successBlock;

@end
