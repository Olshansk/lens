//
//  Message.m
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "Message.h"
#import "Person.h"

static NSString* const DateKey = @"Date";
static NSString* const TextKey = @"Text";
static NSString* const ImageKey = @"Image";

@implementation Message

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
		_image = [decoder decodeObjectForKey:ImageKey];
		_date = [decoder decodeObjectForKey:DateKey];
		_text = [decoder decodeObjectForKey:TextKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:_image forKey:ImageKey];
	[encoder encodeObject:_date forKey:DateKey];
	[encoder encodeObject:_text forKey:TextKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
