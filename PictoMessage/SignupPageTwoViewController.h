//
//  SignupPageTwoViewController.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupPageTwoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak) IBOutlet UIImageView *backgroundView;
@property (weak) IBOutlet UITextField *phoneNumberTextField;
@property (weak) IBOutlet UIButton *countryCodeButton;
@property (weak) IBOutlet UIButton *continueButton;
@property (weak) IBOutlet UIPickerView *pickerView;

-(IBAction)selectCountryCodeAction:(id)sender;
-(IBAction)continueAction:(id)sender;


@end
