//
//  SignupPageOneViewController.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupPageOneViewController : UIViewController

@property (weak) IBOutlet UIImageView *backgroundView;
@property (weak) IBOutlet UIButton *continueButton;

-(IBAction)continueAction:(id)sender;

@end
