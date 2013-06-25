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
@property (nonatomic, strong) UIImage *profileImg;
@property (nonatomic, assign) BOOL isExistingAccount;

-(void)updateLayoutWithHeight:(NSInteger)cellHeight;
-(void)updateData;


@end
