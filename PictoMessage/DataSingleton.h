//
//  DataSingleton.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-08.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface DataSingleton : NSObject

@property (nonatomic, strong) NSString* remoteNotificationToken;
@property (nonatomic, strong) NSString* openUDID;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, strong) UIImage* profilePhoto;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, strong) NSString* currentConvoID;
@property (nonatomic, strong) NSString* background;

+(DataSingleton *)sharedSingleton;
-(void)save;

@end
