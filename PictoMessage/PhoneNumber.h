//
//  PhoneNumber.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-29.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Person;

@interface PhoneNumber : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) Person *phonenumberowner;

@end