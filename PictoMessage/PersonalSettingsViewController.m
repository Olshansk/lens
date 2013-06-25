//
//  PersonalSettingsViewController.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-11.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PersonalSettingsViewController.h"
#import "PersonalSettingsDefs.h"
#import "DataSingleton.h"
#import "UIView+EasyDimensions.h"

#define TITLE_TEXT NSLocalizedString(@"Settings",@"Settings")
#define FEEDBACK_TEXT NSLocalizedString(@"Feedback & Support",@"Feedback & Support")
#define HEIGHT_BETWEEN_GROUPS 5
#define FEEDBACK_BUTTON_HEIGHT 60
#define FEEDBACK_HEIGHT_FROM_BOTTOM 20
#define BACKGROUND_PREVIEW_EXTRA_MARGIN 10
@implementation PersonalSettingsViewController {
    UIImageView* profilePhotoImageView;
    
    UIButton* takePhotoButton;
    
    UITableView* tableView;
    
    UITextField *nameTextField;
    UITextField *emailTextField;
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
    
    [self setTitle:TITLE_TEXT];
    
    profilePhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(HORIZONTAL_MARGINS, VERTICAL_MARGINS + PORTRAIT_STATUS_NAV_BAR_HEIGHT, PROFILE_PHOTO_SIZE, PROFILE_PHOTO_SIZE)];
    [profilePhotoImageView setClipsToBounds:YES];
    [[profilePhotoImageView layer] setCornerRadius:PROFILE_PHOTO_SIZE/2];
    [profilePhotoImageView setImage:[UIImage imageNamed:@"wolf.jpg"]];
    
    CGFloat updateProfilePhotoSize = PROFILE_PHOTO_SIZE / 3;
    UIImage *updateProfilePhotoImage = [UIImage imageNamed:@"UpdateProfilePhoto.png"];
    UIButton *updateProfilePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateProfilePhotoButton setImage:updateProfilePhotoImage forState:UIControlStateNormal];
    [updateProfilePhotoButton setFrame:CGRectMake([profilePhotoImageView bottomRightX] -updateProfilePhotoSize, [profilePhotoImageView bottomRightY] - updateProfilePhotoSize, updateProfilePhotoSize, updateProfilePhotoSize)];
    [updateProfilePhotoButton addTarget:self action:@selector(selectNewPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake([profilePhotoImageView topRightX], [profilePhotoImageView topRightY], self.view.frame.size.width - [profilePhotoImageView topRightX] - 2 * HORIZONTAL_MARGINS, profilePhotoImageView.frame.size.height/2)];
    [phoneNumberLabel setFont:PHONE_FONT];
    [phoneNumberLabel setTextColor:[UIColor whiteColor]];
    [phoneNumberLabel setText:@"647-895-6144"];
    [phoneNumberLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel* yourPhoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake([phoneNumberLabel bottomLeftX], [phoneNumberLabel bottomLeftY] + VERTICAL_MARGINS, phoneNumberLabel.frame.size.width, profilePhotoImageView.frame.size.height/2)];
    [yourPhoneNumberLabel setFont:PHONE_FONT];
    [yourPhoneNumberLabel setTextColor:[UIColor whiteColor]];
    [yourPhoneNumberLabel setText:PHONE_NUMBER_TEXT];
    [yourPhoneNumberLabel setTextAlignment:NSTextAlignmentCenter];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [profilePhotoImageView bottomLeftY], self.view.frame.size.width, self.view.frame.size.height - [profilePhotoImageView bottomLeftY]) style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
//    UIView *
    
    nameTextField = [[UITextField alloc] initWithFrame:TEXT_FIELD_IN_TABLE_CELL_RECT];
    [nameTextField setAdjustsFontSizeToFitWidth: YES];
    [nameTextField setTextColor: [UIColor blackColor]];
    [nameTextField setKeyboardType:UIKeyboardTypeDefault];
    [nameTextField setReturnKeyType:UIReturnKeyDone];
    [nameTextField setBackgroundColor:[UIColor clearColor]];
    [nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [nameTextField setClearButtonMode:UITextFieldViewModeNever];
    
    emailTextField = [[UITextField alloc] initWithFrame:TEXT_FIELD_IN_TABLE_CELL_RECT];
    [emailTextField setAdjustsFontSizeToFitWidth: YES];
    [emailTextField setTextColor: [UIColor blackColor]];
    [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailTextField setReturnKeyType:UIReturnKeyDone];
    [emailTextField setBackgroundColor:[UIColor clearColor]];
    [emailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [emailTextField setClearButtonMode:UITextFieldViewModeNever];
    
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[DataSingleton sharedSingleton] background]]];
    
    UIButton *feedbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedbackButton setFrame:CGRectMake(0, self.view.frame.size.height - FEEDBACK_BUTTON_HEIGHT - FEEDBACK_HEIGHT_FROM_BOTTOM, self.view.frame.size.width, FEEDBACK_BUTTON_HEIGHT)];
//    [[feedbackButton titleLabel] setText:FEEDBACK_TEXT];
//    [[feedbackButton titleLabel] setBackgroundColor:[UIColor blueColor]];
    [feedbackButton setTitle:FEEDBACK_TEXT forState:UIControlStateNormal];
    [feedbackButton setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:backgroundView];
    [self.view addSubview:profilePhotoImageView];
    [self.view addSubview:updateProfilePhotoButton];
    [self.view addSubview:phoneNumberLabel];
    [self.view addSubview:yourPhoneNumberLabel];
    [self.view addSubview:tableView];
    [self.view addSubview:feedbackButton];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)pickNewProfileImage
{
    
}

-(void)selectNewPhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [[cell textLabel] setText:NAME_TEXT];
            [[cell contentView] addSubview:nameTextField];
        } else if (indexPath.row == 1) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [[cell textLabel] setText:EMAIL_TEXT];
            [[cell contentView] addSubview:emailTextField];
        }
    } else if (indexPath.section == 1) {
        [[cell textLabel] setText:NOTIFICATIONS_TEXT];
    } else if (indexPath.section == 2) {
        [[cell textLabel] setText:BACKGROUND_TEXT];
        
        CGRect rect = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:[tableView superview]];
        
        CGFloat circleViewSize = cell.frame.size.height + BACKGROUND_PREVIEW_EXTRA_MARGIN * 2;
        UIView *previewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(120, rect.origin.y -BACKGROUND_PREVIEW_EXTRA_MARGIN, circleViewSize, circleViewSize)];
        [previewBackgroundView setClipsToBounds:YES];
        [previewBackgroundView.layer setCornerRadius:30];
        [previewBackgroundView setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:previewBackgroundView];
        
        
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_BETWEEN_GROUPS;
}

//-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5.0;
//}

#pragma mark UITableViewDelegate

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [profilePhotoImageView setImage:image];
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

@end
