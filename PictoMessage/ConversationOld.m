//
//  Conversation.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-02.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "Conversation.h"
#import "Person.h"
#import "Message.h"

#import "NSMutableArray+SaveAndLoadCustomMutableArrays.h"

static NSString* const ReceiverKey = @"Receiver";
static NSString* const MessagesKey = @"Messages";
static NSString* const ConvoIDKey = @"ConvoID";

@implementation Conversation

- (id)init
{
    if (self = [super init])
    {
        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
		_reciever = [decoder decodeObjectForKey:ReceiverKey];
        _convoID = [decoder decodeObjectForKey:ConvoIDKey];
        _messages = [[NSMutableArray alloc] initWithLoadKey:MessagesKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:_reciever forKey:ReceiverKey];
    [encoder encodeObject:_convoID forKey:ConvoIDKey];
    [_messages saveArrayWithKey:MessagesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)addMessage:(Message*)message
{
	[self.messages addObject:message];
    [_messages saveArrayWithKey:MessagesKey];
	return self.messages.count - 1;
}

@end
