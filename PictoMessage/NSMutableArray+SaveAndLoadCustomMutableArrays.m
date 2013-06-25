//
//  NSMutableArray+SaveAndLoadCustomMutableArrays.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-15.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "NSMutableArray+SaveAndLoadCustomMutableArrays.h"

@implementation NSMutableArray (SaveAndLoadCustomMutableArrays)

-(id)initWithLoadKey:(NSString*)key
{
    self = [[NSMutableArray alloc] init];
    if (self) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *encodedConversations = [prefs objectForKey:key];
        if (encodedConversations != nil) {
            NSArray *conversationsArray = [NSKeyedUnarchiver unarchiveObjectWithData:encodedConversations];
            if (conversationsArray != nil) {
                self = [[NSMutableArray alloc] initWithArray:conversationsArray];
            }
        }
    }
    return self;
}

-(void)saveArrayWithKey:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [prefs setObject:encodedData forKey:key];
    [prefs synchronize];
}


@end
