//
//  NSArray+CoreDataArray.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CoreDataArray)

+(NSArray*)arrayFromCoreDataWithEntityName:(NSString*)entity andPredicateFormat:(NSString*)predicate;

@end
