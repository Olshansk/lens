//
//  CaptureSessionManager.h
//  PictoMessage
//
//  Created by Daniel Olshansky on 2013-05-27.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#define kImageCapturedSuccessfully @"imageCapturedSuccessfully"

@interface CaptureSessionManager : NSObject

@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;

- (void)addVideoInput;
- (void)addStillImageOutput;
- (void)captureStillImage;


@end