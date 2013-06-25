//
//  AccountCreationController.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-02.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "AppDelegate.h"
#import "AccountCreationController.h"

#import "DataSingleton.h"
#import "NetworkProtocol.h"
#import "defs.h"

@interface AccountCreationController ()

@end

@implementation AccountCreationController {
    UITextField *phoneNumberTextField;
    UIButton *submitButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [phoneNumberTextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundColor:[UIColor redColor]];
    [submitButton setFrame:CGRectMake(100, 200, 100, 50)];
    [submitButton addTarget:self action:@selector(submitAccountInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitButton];
    [self.view addSubview:phoneNumberTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)submitAccountInfo:(id)sender
{
    [self createAccountWithPhoneNumber:[phoneNumberTextField text]];
}

-(void)createAccountWithPhoneNumber:(NSString*)phoneNumber
{
    NSDictionary *params = @{USER_DEVICE_TOKEN_PARAM : [[DataSingleton sharedSingleton] remoteNotificationToken], USER_PHONE_PARAM : phoneNumber, USER_AUTH_TOKEN_PARAM:  [[DataSingleton sharedSingleton] openUDID]};
    
    [NetworkProtocol post:params to:USERS_ROOT withSuccessBlock:^(NSDictionary * result) {
        
        
    }];
}


@end
