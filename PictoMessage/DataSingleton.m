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

static NSString* const ConversationsKey = @"ConversationsKey";
static NSString* const UsersWithAccountsKey = @"UsersWithAccountsKey";
static NSString* const RemoteNotificationKey = @"RemoteNotificationKey";
static NSString* const OpenUDIDKey = @"OpenUDIDKey";
static NSString* const UserKey = @"UserKey";
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
            
            if (![prefs boolForKey:isFirstSingletonLoadKey]) {
                
                sharedSingleton = [[DataSingleton alloc] init];
                
                [sharedSingleton setOpenUDID:[OpenUDID value]];
                [sharedSingleton setBackground:@"Alamo.png"];
                [[sharedSingleton user] setActivePhoneNumbers:[[NSMutableArray alloc] initWithArray:@[@"4157355911"]]];//sam: 5195049672 ronen:4158252307
                [[sharedSingleton user] setProfilePhoto:[UIImage imageNamed:@"wolf.jpg"]];
                [[sharedSingleton user] setUserName:@"Daniel Olshansky"];
                
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
        _conversations = [[NSMutableArray alloc] init];
        _usersWithAccounts = [[NSMutableArray alloc] init];
        _user = [[Person alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
        _conversations = [[NSMutableArray alloc] initWithLoadKey:ConversationsKey];
        _usersWithAccounts = [[NSMutableArray alloc] initWithLoadKey:UsersWithAccountsKey];
        _remoteNotificationToken = [decoder decodeObjectForKey:RemoteNotificationKey];
		_openUDID = [decoder decodeObjectForKey:OpenUDIDKey];
		_user = [decoder decodeObjectForKey:UserKey];
        _isVerified = [decoder decodeBoolForKey:IsVerifiedKey];
        _background = [decoder decodeObjectForKey:BackgroundKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [_conversations saveArrayWithKey:ConversationsKey];
    [_usersWithAccounts saveArrayWithKey:UsersWithAccountsKey];
    [encoder encodeObject:_remoteNotificationToken forKey:RemoteNotificationKey];
    [encoder encodeObject:_openUDID forKey:OpenUDIDKey];
    [encoder encodeObject:_user forKey:UserKey];
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
