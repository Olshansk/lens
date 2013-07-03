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
