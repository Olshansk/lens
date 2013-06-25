//
//  Person.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-02.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "Person.h"

#import "NSMutableArray+SaveAndLoadCustomMutableArrays.h"

static NSString* const PhoneNumbersKey = @"PhoneNumbers";
static NSString* const EmailsKey = @"Emails";
static NSString* const ActivePhoneNumbersKey = @"ActivePhoneNumbers";
static NSString* const NameKey = @"Name";
static NSString* const profilePhotoKey = @"profilePhoto";
static NSString* const lastActiceKey = @"lastActive";

@implementation Person

- (id)init
{
    if ((self = [super init]))
	{
        _phoneNumbers = [[NSMutableArray alloc] init];
        _activePhoneNumbers = [[NSMutableArray alloc] init];
        _emails = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
        _phoneNumbers = [[NSMutableArray alloc] initWithLoadKey:PhoneNumbersKey];
        _emails = [[NSMutableArray alloc] initWithLoadKey:EmailsKey];
        _activePhoneNumbers = [[NSMutableArray alloc] initWithLoadKey:ActivePhoneNumbersKey];
		_userName = [decoder decodeObjectForKey:NameKey];
		_profilePhoto = [decoder decodeObjectForKey:profilePhotoKey];
        _lastActive = [decoder decodeObjectForKey:lastActiceKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [_phoneNumbers saveArrayWithKey:PhoneNumbersKey];
    [_emails saveArrayWithKey:EmailsKey];
    [_activePhoneNumbers saveArrayWithKey:ActivePhoneNumbersKey];
    [encoder encodeObject:_userName forKey:NameKey];
    [encoder encodeObject:_profilePhoto forKey:profilePhotoKey];
    [encoder encodeObject:_lastActive forKey:lastActiceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)save
{
    [_phoneNumbers saveArrayWithKey:PhoneNumbersKey];
    [_emails saveArrayWithKey:EmailsKey];
    [_activePhoneNumbers saveArrayWithKey:ActivePhoneNumbersKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setPhoneNumbers:_phoneNumbers];
        [copy setActivePhoneNumbers:_activePhoneNumbers];
        [copy setEmails:_emails];
        [copy setUserName:_userName];
        [copy setProfilePhoto:_profilePhoto];
        [copy setLastActive:_lastActive];
    }
    
    return copy;
}

@end
