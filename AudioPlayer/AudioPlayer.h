//
//  AudioPlayer.h
//  HLWAudio
//
//  Created by 黄黎雯 on 2017/8/7.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioButton;
@class AudioStreamer;
@protocol AudioPlayerDelegate <NSObject>

-(void)bofangwc;
-(void)bofangstop;

@end
@interface AudioPlayer : NSObject {
    AudioStreamer *streamer;
    AudioButton *button;
    NSURL *url;
    NSTimer *timer;
}

/**
 *  得到单例
 *
 *  @return 单例的对象
 */
+ (id)getInstance;

@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) AudioButton *button;
@property (nonatomic, retain) NSURL *url;
@property (strong,nonatomic) id<AudioPlayerDelegate>delegate;
- (void)play;
- (void)stop;
- (BOOL)isProcessing;
- (BOOL)isPlay;
-(void)ycplay;
-(void)ycstop;
@end
