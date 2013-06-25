//
//  MessageView.h
//  PictoMessage
//
//  Created by Daniel Olshansky on 2013-05-27.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UITableViewCell

- (void)setCellText:(NSString*)text withThumbnailImage:(UIImage*)image isFromMe:(bool)isFromMe;
+ (CGFloat)getHeightForText:(NSString*)text withTotalWidth:(CGFloat)width;

@end
