//
//  DataSingleton.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-08.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "DataSingleton.h"
#import "OpenUDID.h"
#import "Person.h"

#import "NSMutableArray+SaveAndLoadCustomMutableArrays.h"

static NSString* const RemoteNotificationKey = @"RemoteNotificationKey";
static NSString* const OpenUDIDKey = @"OpenUDIDKey";
static NSString* const IsVerifiedKey = @"IsVerifiedKey";
static NSString* const BackgroundKey = @"BackgroundKey";

static NSString* const SingletonKey = @"SingletonKey";
static NSString* const isFirstSingletonLoadKey = @"isFirstSingletonLoad";

@implementation DataSingleton

+ (DataSingleton *)sharedSingleton
{
    static DataSingleton *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
                [prefs setBool:NO forKey:isFirstSingletonLoadKey];
            if (![prefs boolForKey:isFirstSingletonLoadKey]) {
                
                sharedSingleton = [[DataSingleton alloc] init];
                
                [sharedSingleton setOpenUDID:[OpenUDID value]];
                NSLog(@"UDID: %@", [sharedSingleton openUDID]);
                [sharedSingleton setBackground:@"Alamo.png"];
                [sharedSingleton setPhoneNumber:@"5195049672"];//sam: 5195049672 ronen:4158252307 jordan:
                [sharedSingleton setProfilePhoto:[UIImage imageNamed:@"wolf.jpg"]];
                [sharedSingleton setUserName:@"Daniel Olshansky"];
                
                [prefs setBool:YES forKey:isFirstSingletonLoadKey];
            } else {
                NSData *data = [prefs objectForKey:SingletonKey];
                sharedSingleton = (DataSingleton *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
        }
        
        return sharedSingleton;
    }
}

-(id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
        _remoteNotificationToken = [decoder decodeObjectForKey:RemoteNotificationKey];
		_openUDID = [decoder decodeObjectForKey:OpenUDIDKey];
        _isVerified = [decoder decodeBoolForKey:IsVerifiedKey];
        _background = [decoder decodeObjectForKey:BackgroundKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:_remoteNotificationToken forKey:RemoteNotificationKey];
    [encoder encodeObject:_openUDID forKey:OpenUDIDKey];
    [encoder encodeBool:_isVerified forKey:IsVerifiedKey];
    [encoder encodeObject:_background forKey:BackgroundKey];
}

-(void)save
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [prefs setObject:data forKey:SingletonKey];
    [prefs synchronize];
}

@end
