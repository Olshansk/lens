//
//  SignupPageThreeViewController.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupPageThreeViewController : UIViewController

@property (weak) IBOutlet UILabel *verificationInfoLabel;
@property (weak) IBOutlet UIImageView *backgroundView;
@property (weak) IBOutlet UITextField *verificationCodeTextField;
@property (weak) IBOutlet UIButton *continueButton;
@property (weak) IBOutlet UIButton *resendVerificationButton;

-(IBAction)resendVerificationCode:(id)sender;
-(IBAction)continueAction:(id)sender;


@end
