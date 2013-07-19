//
//  AccountTableViewCell.h
//  Jellyfish
//
//  Created by Daniel Olshansky on 2013-06-22.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *profilePhoto;
//@property (nonatomic, assign) BOOL isExistingAccount;

@property (nonatomic, weak) IBOutlet UIImageView *profilePhotoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *actionIconImageView;

@property (nonatomic, weak) IBOutlet UILabel *profileNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *actionLabel;

-(void)updateLayoutWithHeight:(NSInteger)cellHeight;
-(void)updateData;


@end
