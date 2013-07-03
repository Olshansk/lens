//
//  SignupPageFourViewController.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupPageFourViewController : UIViewController

@property (weak) IBOutlet UIImageView *profilePhotoImageView;
@property (weak) IBOutlet UITextField *nameTextField;
@property (weak) IBOutlet UIButton *continueButton;
@property (weak) IBOutlet UIButton *profilePhotoButton;
@property (weak) IBOutlet UIImageView *backgroundView;

-(IBAction)chooseProfilePhoto:(id)sender;
-(IBAction)continueAction:(id)sender;

@end
