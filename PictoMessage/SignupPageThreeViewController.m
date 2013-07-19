//
//  SignupPageThreeViewController.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "SignupPageThreeViewController.h"
#import "SignupPageFourViewController.h"
#import "DataSingleton.h"
#import "NetworkProtocol.h"
#import "defs.h"

@implementation SignupPageThreeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *backgroundImage = [UIImage imageNamed:[[DataSingleton sharedSingleton] background]];
    [_backgroundView setImage:backgroundImage];
    
    [_continueButton setEnabled:NO];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [_verificationCodeTextField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newString length] >= 4) {
        
//        NSDictionary *params = @{PHONE_CONFIRM_CODE_PARAM: newString/*USER_DEVICE_TOKEN_PARAM : [[DataSingleton sharedSingleton] remoteNotificationToken]*/, USER_PHONE_PARAM: [[DataSingleton sharedSingleton] phoneNumber], USER_AUTH_TOKEN_PARAM:  [[DataSingleton sharedSingleton] openUDID]};
//        
//        [NetworkProtocol put:params from:VERIFY_USER_ROOT withSuccessBlock:^(NSDictionary * result) {
//            
//            
//        }];
//
//        [NetworkProtocol put:<#(NSDictionary *)#> from:<#(NSString *)#> withSuccessBlock:<#^(NSDictionary *)successBlock#>]
    }
    
    return YES;
}

#pragma mark IBActions

-(IBAction)resendVerificationCode:(id)sender
{
    
}

-(IBAction)continueAction:(id)sender
{
    SignupPageFourViewController *page4 = [[SignupPageFourViewController alloc] init];
    [self presentViewController:page4 animated:NO completion:nil];
}


@end
