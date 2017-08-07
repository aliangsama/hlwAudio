//
//  AudioButton.h
//  HLWAudio
//
//  Created by 黄黎雯 on 2017/8/7.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MB_AUTORELEASE(exp) exp
extern NSString *playImage, *stopImage;

@interface AudioButton : UIButton {

	CGFloat _r;
	CGFloat _g;
	CGFloat _b;
	CGFloat _a;
	
	CGFloat _progress;
	
	CGRect _outerCircleRect;
	CGRect _innerCircleRect;
    
    UIImage *image;
    UIView *loadingView;
}

@property (nonatomic, retain) UIImage *image;

- (id)initWithFrame:(CGRect)frame;
- (void)startSpin;
- (void)stopSpin;
- (CGFloat)progress;
- (void)setProgress:(CGFloat)newProgress;		
- (void)setColourR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;	

@end
