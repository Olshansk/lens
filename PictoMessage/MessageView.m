//
//  MessageView.m
//  PictoMessage
//
//  Created by Daniel Olshansky on 2013-05-27.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import "MessageView.h"

#import "UIView+EasyDimensions.h"

#define FONT_SIZE 14.0f
#define X_MARGIN 10
#define Y_MARGIN 10
#define THUMBNAIL_SIZE 40.0f
#define TEXT_INSET 10
@implementation MessageView {
    
    UIImageView *thumbnailView;
    UILabel *textLabel;
    UIImageView *textBubble; 
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;

        thumbnailView = [[UIImageView alloc] init];
        
        textBubble = [[UIImageView alloc] init];
        
        textLabel = [[UILabel alloc] init];
        [textLabel setNumberOfLines:0];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:thumbnailView];
        [self addSubview:textBubble];
        [self addSubview:textLabel];
	}
	return self;
}

- (void)setCellText:(NSString*)text withThumbnailImage:(UIImage*)image isFromMe:(bool)isFromMe
{
    UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
    
//    text = @"ASDASDASDKASDKJASDJKASHDJKSAHDKJASHDKJASHDKJASHKDJASHKDAKSJHDJKSAHJKDASASDASDASDKASDKJASDJKASHDJKSAHDKJASHDKJASHDKJASHKDJASHKDAKSJHDJKSAHJKDASASDASDASDKASDKJASDJKASHDJKSAHDKJASHDKJASHDKJASHKDJASHKDAKSJHDJKSAHJKDASASDASDASDKASDKJASDJKASHDJKSAHDKJASHDKJASHDKJASHKDJASHKDAKSJHDJKSAHJKDASASDASDASDKASDKJASDJKASHDJKSAHDKJASHDKJASHDKJASHKDJASHKDAKSJHDJKSAHJKDASASDASDASDKASDKJASDJKASHDJKSAHDKJASHDKJASHDKJASHKDJASHKDAKSJHDJKSAHJKDAS";
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(self.frame.size.width - X_MARGIN * 3 - THUMBNAIL_SIZE - TEXT_INSET * 2, 9999) lineBreakMode:NSLineBreakByWordWrapping];

    UIImage *bubbleImage;
    
    if (isFromMe) {
        bubbleImage = [UIImage imageNamed:@"BlueBubble.png"];
        [thumbnailView setFrame:CGRectMake(self.frame.size.width - X_MARGIN - THUMBNAIL_SIZE, Y_MARGIN , THUMBNAIL_SIZE, THUMBNAIL_SIZE)];
        [textBubble setFrame:CGRectMake(self.frame.size.width - X_MARGIN * 2 - THUMBNAIL_SIZE - size.width - TEXT_INSET * 2, Y_MARGIN, size.width + TEXT_INSET * 2, fmin(bubbleImage.size.height, size.height) + TEXT_INSET * 2)];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 12, 12, 20) resizingMode:UIImageResizingModeStretch];
        [textLabel setFrame:CGRectMake([textBubble topLeftX] + TEXT_INSET, [textBubble topLeftY] + TEXT_INSET, size.width, size.height)];
        //top left bottom right
    }
    else {
        bubbleImage = [UIImage imageNamed:@"WhiteBubble.png"];
        [thumbnailView setFrame:CGRectMake(X_MARGIN, Y_MARGIN , THUMBNAIL_SIZE, THUMBNAIL_SIZE)];
        [textBubble setFrame:CGRectMake([thumbnailView topRightX] + X_MARGIN, Y_MARGIN, size.width, size.height)];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 12, 12) resizingMode:UIImageResizingModeStretch];
        [textLabel setFrame:CGRectMake([textBubble topLeftX] + TEXT_INSET, [textBubble topLeftY] + TEXT_INSET, size.width, size.height)];
    }
    [thumbnailView setImage:image];
    [textLabel setText:text];
    [textLabel setFont:font];
    [textBubble setImage:bubbleImage];
}

+(CGFloat)getHeightForText:(NSString*)text withTotalWidth:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
    
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width - X_MARGIN * 3 - THUMBNAIL_SIZE - TEXT_INSET * 2, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = Y_MARGIN * 2 + MAX(THUMBNAIL_SIZE, size.height);
    
    return height;
}

@end
