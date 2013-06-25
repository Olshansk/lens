//
//  Person.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-02.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCopying>

@property (nonatomic, retain) NSMutableArray *phoneNumbers;
@property (nonatomic, retain) NSMutableArray *activePhoneNumbers;
@property (nonatomic, retain) NSMutableArray *emails;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) UIImage *profilePhoto;
@property (nonatomic, retain) NSString *lastActive;

-(void)save;

@end
