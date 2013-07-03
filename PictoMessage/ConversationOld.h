//
//  Conversation.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-02.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;
@class Message;

@interface Conversation : NSObject

@property (nonatomic, strong) NSMutableArray* messages;
@property (nonatomic, strong) NSString* convoID;
@property (nonatomic, copy) Person* reciever;

- (int)addMessage:(Message*)message;

@end
