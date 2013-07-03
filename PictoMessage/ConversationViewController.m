//
//  ConversationViewController.m
//  PictoMessage
//
//  Created by Daniel Olshansky on 2013-05-27.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "DataSingleton.h"
#import "ConversationViewController.h"
#import "CaptureSessionManager.h"
#import "MessageView.h"

#import "defs.h"

#import "AppDelegate.h"
#import "Message.h"

#import "Conversation.h"

#import "defs.h"

#import "ConversationViewControllerDefs.h"
#import "NetworkProtocol.h"
#import "DataSingleton.h"
#import "Person.h"

@implementation ConversationViewController
{
    CaptureSessionManager *captureManager;
    KeyboardAccessoryTextView *accessoryView;
    
    UIImageView *backgroundView;
    
    UIImage *backgroundImage;
    
    UITableView *tableView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *temp1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [temp1 setBackgroundColor:[UIColor blackColor]];
    [temp1 addTarget:self action:@selector(temp1) forControlEvents:UIControlEventTouchUpInside];
    [temp1 setFrame:CGRectMake(0, 100, 100, 50)];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapScrollView:)];
    
    backgroundView = [[UIImageView alloc] init];
    [backgroundView setFrame:CGRectMake(-30, -30, self.view.frame.size.width + 30*2, self.view.frame.size.height + 30*2)];
        
    captureManager = [[CaptureSessionManager alloc] init];
    [captureManager addVideoInput];
    [captureManager addStillImageOutput];
    [[captureManager captureSession] startRunning];
    
    accessoryView = [[KeyboardAccessoryTextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - ACCESSORY_VIEW_HEIGHT, self.view.frame.size.width, ACCESSORY_VIEW_HEIGHT)];
    [accessoryView setDelegate:self];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - ACCESSORY_VIEW_HEIGHT) style:UITableViewStylePlain];
    [tableView setContentInset:UIEdgeInsetsMake(VERTICAL_CONTENT_INSET, 0, 0, 0)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView addGestureRecognizer:tapGestureRecognizer];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:backgroundView];
    [self.view addSubview:tableView];
    [self.view addSubview:accessoryView];
    [self.view addSubview:temp1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImage:) name:kImageCapturedSuccessfully object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kImageCapturedSuccessfully object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[DataSingleton sharedSingleton] setCurrentConvoID:[_conversation conversationID]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[DataSingleton sharedSingleton] setCurrentConvoID:nil];
}

-(void)temp1
{
    [captureManager captureStillImage];

    AppDelegate *delegate = APP_DELEGATE;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    Message* message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    
    [message setConversation:_conversation];
    [_conversation addMessagesObject:message];
    
	message.date = [NSDate date];
	message.text = @"Me";

    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[_conversation messages] count] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self scrollToNewestMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark KeyboardAccessoryTextViewDelegate

-(void) didSubmitQuestion:(NSString*)message
{
    [self sendMessage:message];
}

#define Capture Still Image

- (void)saveImage:(id)sender
{
    backgroundImage = [captureManager stillImage];
    [backgroundView setImage:backgroundImage];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(aniamteImageBlurEffect:) userInfo:nil repeats:NO];
}

-(void)aniamteImageBlurEffect:(id)sender
{
    UIImage *blurredImage = [self blurImage:backgroundImage withBlurRadius:20];
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        backgroundView.image = blurredImage;
    } completion:^(BOOL finished) {
    }];
//        IImageView* animatedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        animatedImageView.animationImages = [NSArray arrayWithObjects:
//                                             [UIImage imageNamed:@"image1.gif"],
//                                             [UIImage imageNamed:@"image2.gif"],
//                                             [UIImage imageNamed:@"image3.gif"],
//                                             [UIImage imageNamed:@"image4.gif"], nil];
//        animatedImageView.animationDuration = 1.0f;
//        animatedImageView.animationRepeatCount = 0;
}

-(UIImage*)blurImage:(UIImage*)img withBlurRadius:(CGFloat)blurRadius
{
    CIImage *imageToBlur = [CIImage imageWithCGImage:img.CGImage];
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setValue:imageToBlur forKey:@"inputImage"];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:blurRadius] forKey:@"inputRadius"];
    CIImage *resultImage = [gaussianBlurFilter valueForKey:@"outputImage"];
    UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
    return endImage;
}

#pragma mark Scrollview TapGestureRecognizer

-(void)didTapScrollView:(id)sender
{
    if ([accessoryView isFirstResponder]) {
        [accessoryView resignFirstResponder];
    }
}

#pragma mark UITableViewDataSource

- (int)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return _conversation.messages.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableview cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* CellIdentifier = @"MessageCellIdentifier";
    
	MessageView* cell = (MessageView*)[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[MessageView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	Message* message = ([[_conversation messages] allObjects])[indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setCellText:message.text withThumbnailImage:[UIImage imageNamed:@"img.jpg"] isFromMe:indexPath.row % 2 == 0];
	return cell;
}

#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	Message* message = ([[_conversation messages] allObjects])[indexPath.row];
    return [MessageView getHeightForText:message.text withTotalWidth:self.view.frame.size.width];
}

- (void)scrollToNewestMessage
{
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(_conversation.messages.count - 1) inSection:0];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark KeyboardAnimations


-(void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
        accessoryView.center = CGPointMake(accessoryView.center.x, (accessoryView.center.y - [self keyboardHeightForNotification:notification]));
    } completion:NULL];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:[self keyboardAnimationDurationForNotification:notification] delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
        accessoryView.center = CGPointMake(accessoryView.center.x, (accessoryView.center.y + [self keyboardHeightForNotification:notification]));
    } completion:NULL];
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

-(CGFloat)keyboardHeightForNotification:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    return keyboardFrameBeginRect.size.height;
}

#pragma mark KeyboardAccessoryTextViewDelegate

-(void) didSendMessage:(NSString *)text
{
    [captureManager captureStillImage];

    AppDelegate *delegate = APP_DELEGATE;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    Message* message = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    
    [message setConversation:_conversation];
    [_conversation addMessagesObject:message];

	message.date = [NSDate date];
	message.text = text;
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[[_conversation messages] count] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self scrollToNewestMessage];
    
    [self sendMessage:text];

}

#pragma mark Network Stuff

- (void)sendMessage:(NSString*)message
{
    NSDictionary *getURLParams = @{AUTH_TOKEN_PARAM: [[DataSingleton sharedSingleton] openUDID], PARAM_PHONE : [[DataSingleton sharedSingleton] phoneNumber]};
    NSString *from = [NSString stringWithFormat:@"%@/%@/%@/%@", CONVERSATION_ROOT, [_conversation conversationID], MESSAGES_ROOT, NEW_ROOT];
    
    [NetworkProtocol get:getURLParams from:from withSuccessBlock:^(NSDictionary * dict) {
        NSArray *params = [dict objectForKey:URL_DICT_WRAPPER_KEY];
        
        NSData *imageData = UIImageJPEGRepresentation(backgroundImage, 0.01);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:AWS_ROOT]];
        [request setHTTPMethod:@"POST"];
        
        NSMutableData *body = [NSMutableData data];
        
        int timestamp = [[[NSDate alloc] initWithTimeIntervalSinceNow:0] timeIntervalSince1970];
        NSString *boundary = [NSString stringWithFormat:@"BOUNDARY-%d-%@", timestamp, [[NSProcessInfo processInfo] globallyUniqueString]];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        
        for (NSDictionary *paramDict in params) {
            NSString *key = [[paramDict allKeys] objectAtIndex:0];
            NSString *value = [NSString stringWithFormat:@"%@",[[paramDict allValues] objectAtIndex:0]];//[[[paramDict allValues] objectAtIndex:0] stringValue];
            
            
            if ([key isEqualToString:@"file"]) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, @"TEMP,jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData:imageData]];
                [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }else {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
      
        [request setHTTPBody:body];
        
        [request setTimeoutInterval:15];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
            if (!response) {
                NSLog(@"Network Error: %@", error);
                return;
            } else {
                NSLog(@"%@", response);
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSString *url = [[httpResponse allHeaderFields] objectForKey:@"Location"];
                
                NSDictionary *parms = @{AUTH_TOKEN_PARAM: [[DataSingleton sharedSingleton] openUDID], MESSAGE_CONTENT_PARAM: message, MESSAGE_PHOTO_URL: url, PARAM_PHONE : [[DataSingleton sharedSingleton] phoneNumber]};
                
                NSString *to = [NSString stringWithFormat:@"%@/%@/%@",CONVERSATION_ROOT,[_conversation conversationID],MESSAGES_ROOT];
                
                [NetworkProtocol post:parms to:to withSuccessBlock:^(NSDictionary * dict) {
                    
                    
                }];

                
            }
        }];
        
    }];
}

@end
