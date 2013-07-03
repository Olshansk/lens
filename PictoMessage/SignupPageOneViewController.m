//
//  SignupPageOneViewController.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "SignupPageOneViewController.h"
#import "SignupPageTwoViewController.h"
#import "DataSingleton.h"


@implementation SignupPageOneViewController

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

#pragma mark IBAction

-(IBAction)continueAction:(id)sender
{
    SignupPageTwoViewController *pageTwo = [[SignupPageTwoViewController alloc] init];
    [self presentViewController:pageTwo animated:NO completion:nil];
}

@end
