//
//  NSArray+CoreDataArray.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "NSArray+CoreDataArray.h"

@implementation NSArray (CoreDataArray)

+(NSArray*)arrayFromCoreDataWithEntityName:(NSString*)entity andPredicateFormat:(NSString*)predicate
{
    AppDelegate *delegate = APP_DELEGATE;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    if (predicate != nil && ![predicate isEqualToString:@""]) {
        [request setPredicate:[NSPredicate predicateWithFormat:predicate]];
    }
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:request error:&error];
    return array;
}

@end
