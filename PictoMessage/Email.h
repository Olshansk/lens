//
//  Email.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-29.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface Email : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) Person *emailOwner;

@end
