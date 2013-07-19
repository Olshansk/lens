//
//  AccountTableViewCell.m
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-22.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "UIView+EasyDimensions.h"

#define PROFILE_IMAGE_TOP_BOTTOM_MARGIN 10.0
#define PROFILE_IMAGE_LEFT_MARGIN 10.0
#define PROFILE_IMAGE_RIGHT_MARGIN 10.0
#define NAME_TOP_MARGIN 10.0
#define NAME_RIGHT_MARGIN 10.0
#define NAME_BUTTON_VERTICAL_MARGIN 5.0
#define BUTTON_TEXT_HORIZONTAL_MARGIN 2.0
#define BUTTON_BOTTOM_MARGIN 10.0

#define SEND_INVITE_TEXT NSLocalizedString(@"Send an invite",@"Send an invite")

@implementation AccountTableViewCell /*{
    UIImageView *profilePhoto;
    UILabel *nameLabel;
}*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void)updateLayoutWithHeight:(NSInteger)cellHeight
{
//    CGFloat imgSize = cellHeight - PROFILE_IMAGE_TOP_BOTTOM_MARGIN * 2;
//    profilePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(PROFILE_IMAGE_TOP_BOTTOM_MARGIN, PROFILE_IMAGE_LEFT_MARGIN, imgSize, imgSize)];
//    [profilePhoto setImage:_profilePhoto];
//    [profilePhoto.layer setCornerRadius:imgSize/2];
//    [profilePhoto setClipsToBounds:YES];
//    
//    CGFloat nameLabelHeight = cellHeight / 2 - NAME_TOP_MARGIN - NAME_BUTTON_VERTICAL_MARGIN / 2;
//    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([profilePhoto topRightX] + PROFILE_IMAGE_RIGHT_MARGIN, NAME_TOP_MARGIN, self.frame.size.width - [profilePhoto topRightX] - PROFILE_IMAGE_RIGHT_MARGIN - NAME_RIGHT_MARGIN, nameLabelHeight)];
//    [nameLabel setTextColor:[UIColor whiteColor]];
//    [nameLabel setText:_name];
//    
//    UIImage *image = [UIImage imageNamed:@"InviteIcon.png"];
//    UIImageView *inviteIconImage = [[UIImageView alloc] initWithFrame:CGRectMake([nameLabel bottomLeftX], [nameLabel bottomLeftY] + NAME_BUTTON_VERTICAL_MARGIN, image.size.width , nameLabelHeight)];
//    [inviteIconImage setContentMode:UIViewContentModeCenter];
//    [inviteIconImage setImage:image];
//    
//    UILabel *sendAnInvite = [[UILabel alloc] initWithFrame:CGRectMake([inviteIconImage topRightX] + BUTTON_TEXT_HORIZONTAL_MARGIN, [inviteIconImage topRightY], self.frame.size.width - [inviteIconImage topRightX] - BUTTON_TEXT_HORIZONTAL_MARGIN - NAME_RIGHT_MARGIN, nameLabelHeight)];
//    [sendAnInvite setTextColor:[UIColor whiteColor]];
//    [sendAnInvite setText:SEND_INVITE_TEXT];
    
    //    NSLayoutConstraint *textTop = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-IMAGEVIEW_MARGIN];
    //    NSLayoutConstraint *textBottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-IMAGEVIEW_MARGIN];
    //    NSLayoutConstraint *textMiddle = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-IMAGEVIEW_MARGIN];
    //    NSLayoutConstraint *textImage = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-IMAGEVIEW_MARGIN];
    
//    [self setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:profilePhoto];
//    [self addSubview:nameLabel];
//    [self addSubview:inviteIconImage];
//    [self addSubview:sendAnInvite];
    
}

-(void)updateData {
    [self.profilePhotoImageView setImage:_profilePhoto];
    [self.profileNameLabel setText:_name];
}

@end
