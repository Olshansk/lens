//
//  ConversationViewController.h
//  PictoMessage
//
//  Created by Daniel Olshansky on 2013-05-27.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KeyboardAccessoryTextView.h"

@class Conversation;
@class Message;

@interface ConversationViewController : UIViewController <KeyboardAccessoryTextViewDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) Conversation* conversation;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

-(void)updateScreenWithMessage:(Message*)message;

@end
