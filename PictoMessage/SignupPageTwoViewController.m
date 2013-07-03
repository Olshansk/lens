//
//  SignupPageTwoViewController.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-30.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "SignupPageTwoViewController.h"
#import "SignupPageThreeViewController.h"
#import "DataSingleton.h"

#define PICKER_ANIMATION_DURATION 0

@implementation SignupPageTwoViewController
{
    NSArray *_countryCodeDataArray;
    BOOL _pickerIsVisible;
}
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
    
    _countryCodeDataArray = @[@"US +1", @"AB +2", @"CD +3", @"EF +4", @"GH +5"];
    
    [_pickerView setAlpha:0];
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];
    _pickerIsVisible = NO;
    
    [_phoneNumberTextField setDelegate:self];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [_backgroundView setUserInteractionEnabled:YES];
    [_backgroundView addGestureRecognizer:tapGesture];
}

-(void)checkAndResignFirstResponder
{
    if ([_phoneNumberTextField isFirstResponder]) {
        [_phoneNumberTextField resignFirstResponder];
    }
}

-(void)didTap:(UITapGestureRecognizer*)recognizer
{
    [self checkAndResignFirstResponder];
    if (_pickerIsVisible) {
        [self animatePickerOut];
    }
    
}

-(void)togglePicker
{
    if (_pickerIsVisible) {
        [self animatePickerOut];
    } else {
        [self animatePickerIn];
    }
}

-(void)animatePickerIn
{
    [UIView animateWithDuration:PICKER_ANIMATION_DURATION animations:^{
        [_pickerView setAlpha:1];
    } completion:^(BOOL finished) {
        _pickerIsVisible = YES;
    }];
}

-(void)animatePickerOut
{
    [UIView animateWithDuration:PICKER_ANIMATION_DURATION animations:^{
        [_pickerView setAlpha:0];
    } completion:^(BOOL finished) {
        _pickerIsVisible = NO;
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[textField text] length] == 0) {
        [_continueButton setEnabled:NO];
    } else {
        [_continueButton setEnabled:YES];
    }
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_countryCodeDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_countryCodeButton setTitle:[_countryCodeDataArray objectAtIndex:row] forState:UIControlStateNormal];
}


#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_countryCodeDataArray count];
}


#pragma mark IBAction

-(IBAction)selectCountryCodeAction:(id)sender
{
    [self checkAndResignFirstResponder];
    [self togglePicker];
}

-(IBAction)continueAction:(id)sender
{
    SignupPageThreeViewController *page3 = [[SignupPageThreeViewController alloc] init];
    [self presentViewController:page3 animated:NO completion:nil];
}


@end
