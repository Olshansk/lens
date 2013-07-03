//
//  SignupPageFourViewController.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "SignupPageFourViewController.h"
#import "DataSingleton.h"

@implementation SignupPageFourViewController

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
    
    UIImage *backgroundImage = [UIImage imageNamed:[[DataSingleton sharedSingleton] background]];
    [_backgroundView setImage:backgroundImage];
}

#pragma mark IBActions

-(IBAction)chooseProfilePhoto:(id)sender;
{
    
}

-(IBAction)continueAction:(id)sender
{
}

@end
