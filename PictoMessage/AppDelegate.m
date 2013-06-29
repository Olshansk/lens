//
//  AppDelegate.m
//  PictoMessage
//
//  Created by Daniel Olshansky on 2013-05-27.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//


#import <MessageUI/MessageUI.h>

#import "AppDelegate.h"
#import "ConversationViewController.h"
#import "ConversationsTableViewController.h"
#import "AccountCreationController.h"
#import "PersonalSettingsViewController.h"
#import "DataSingleton.h"
#import "Conversation.h"

#define FIRST_TIME_KEY @"firstTime"
#define CONVO_ID_KEY @"conversation_id"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ConversationsTableViewController * temp = [[ConversationsTableViewController alloc] init];
    PersonalSettingsViewController *temp2 = [[PersonalSettingsViewController alloc] init];
    ConversationViewController *temp3 = [[ConversationViewController alloc] init];
  
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[self getRootViewController]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:temp];
    [[navController navigationBar] setTintColor:[UIColor whiteColor]];

    UIImage *navigationBarBackground = [[UIImage imageNamed:@"TransparentBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[navController navigationBar] setBackgroundImage:navigationBarBackground forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    [self updateConversationsWithLaunchOptions:launchOptions];
    
    [self.window setTintColor:[UIColor whiteColor]];
    [self.window setRootViewController:navController];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [self addMessagesFromRemoteNotification:userInfo updateUI:YES];
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[DataSingleton sharedSingleton] setRemoteNotificationToken:newToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)updateConversationsWithLaunchOptions:(NSDictionary *)launchOptions
{
    if (launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
            [self addMessagesFromRemoteNotification:launchOptions updateUI:NO];
		}
	}
}

- (void)addMessagesFromRemoteNotification:(NSDictionary*)dict updateUI:(BOOL)update
{
    NSString *convoID =  [dict objectForKey:@"conversation_id"];
    NSString *url =  [dict objectForKey:@"url"];
    NSString *msg = [[dict objectForKey:@"aps"] objectForKey:@"alert"]; // [userInfo valueForKey:@"aps.alert"]
    /*
    //Receving message
    //1. Get a notification with convo ID
    //2. GET /conversations/convo_id.json?auth_token=auth_token&phone=<phone_number>&last_message_id=<id>
    //3. - id with last message
         - array of messages
         - array of urls
    
    
    //Sending message
    //1. POST /conversations/convo_id/messages.json?auth_token=auth_token
    //2.
    //3.
   */
    NSString *convo = [dict objectForKey:CONVO_ID_KEY];
    
    for (Conversation *convo in [[DataSingleton sharedSingleton] conversations]) {
        if ([[convo convoID] isEqualToString:convo]) {
            
//            [convoViewController setConversation:convo];
//            [[self navigationController] pushViewController:convoViewController animated:YES];
//            return;
        }
    }
}

- (UIViewController*)getRootViewController
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL isFirstTime = [prefs boolForKey:FIRST_TIME_KEY];
    if (isFirstTime) {
        [prefs setBool:YES forKey:FIRST_TIME_KEY];
        return [[AccountCreationController alloc] init];
    } else {
        return [[ConversationsTableViewController alloc] init];
    }
}

@end
