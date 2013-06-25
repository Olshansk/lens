//
//  NSMutableArray+SaveAndLoadCustomMutableArrays.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-15.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SaveAndLoadCustomMutableArrays)

-(id)initWithLoadKey:(NSString*)key;
-(void)saveArrayWithKey:(NSString*)key;

@end
