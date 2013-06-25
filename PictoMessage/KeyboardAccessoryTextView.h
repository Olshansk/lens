//
//  KeyboardAccessoryTextView.h
//  ProjectOak
//
//  Created by Daniel Olshansky on 2013-01-01.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HPGrowingTextView.h"

@protocol KeyboardAccessoryTextViewDelegate

-(void) didSendMessage:(NSString*)message;

@end

@interface KeyboardAccessoryTextView : UIView <HPGrowingTextViewDelegate>

@property (nonatomic, strong) HPGrowingTextView *textView;
@property (nonatomic, strong) id <KeyboardAccessoryTextViewDelegate> delegate;

- (BOOL)isFirstResponder;
- (void)resignFirstResponder;

@end
