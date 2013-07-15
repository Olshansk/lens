//
//  Message.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-07-14.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * isFromMe;
@property (nonatomic, retain) Conversation *conversation;

@end
