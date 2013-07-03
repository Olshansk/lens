//
//  Person.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Conversation, Email, PhoneNumber;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * lastActive;
@property (nonatomic, retain) UIImage* profilePhoto;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * personID;
@property (nonatomic, retain) Conversation *conversation;
@property (nonatomic, retain) NSSet *emails;
@property (nonatomic, retain) NSSet *phonenumbers;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addEmailsObject:(Email *)value;
- (void)removeEmailsObject:(Email *)value;
- (void)addEmails:(NSSet *)values;
- (void)removeEmails:(NSSet *)values;

- (void)addPhonenumbersObject:(PhoneNumber *)value;
- (void)removePhonenumbersObject:(PhoneNumber *)value;
- (void)addPhonenumbers:(NSSet *)values;
- (void)removePhonenumbers:(NSSet *)values;

@end
