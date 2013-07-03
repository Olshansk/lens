//
//  Message.h
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//
@class Person;

@interface Message : NSObject <NSCoding>

@property (nonatomic, copy) NSDate* date;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, copy) UIImage* image;

@end
