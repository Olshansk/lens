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

@interface ConversationViewController : UIViewController <KeyboardAccessoryTextViewDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) Conversation* conversation;

@end
