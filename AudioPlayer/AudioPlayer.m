//
//  AudioPlayer.m
//  HLWAudio
//
//  Created by 黄黎雯 on 2017/8/7.
//  Copyright © 2017年 hlw. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioButton.h"
#import "AudioStreamer.h"
#import "AudioTimeLabel.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
@implementation AudioPlayer

@synthesize streamer, button, url;

+ (id)getInstance {
    __strong static AudioPlayer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AudioPlayer alloc] init];
    });
    return instance;
}

- (void)dealloc
{
    [super dealloc];
    [url release];
    [streamer release];
    [button release];
    [timer invalidate];
}


- (BOOL)isProcessing
{
    return [streamer isPlaying] || [streamer isWaiting] || [streamer isFinishing] ;
}

- (BOOL)isPlay
{
    return [streamer isPlaying];
}

- (void)play
{        
    if (!streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];    
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             invocation:invocation 
                                                repeats:YES];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:streamer];
    }

    if ([streamer isPlaying]) {
        [streamer pause];
        if (_delegate) {
            [_delegate bofangstop];
        }
    } else {
        [streamer start];
    }
    
}

-(void)ycplay{
    [streamer start];
}
-(void)ycstop{
    [streamer pause];
}

- (void)stop
{    
    [button setProgress:0];
    [button stopSpin];

    button.image = [UIImage imageNamed:playImage];
    button = nil; // 避免播放器的闪烁问题        
    [button release];     
    
    // release streamer
	if (streamer)
	{        
		[streamer stop];
		[streamer release];
		streamer = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:streamer];		
	}
    
}

- (void)updateProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];
    } else {
        [button setProgress:0.0f];        
    }
}

- (void)setLockScreenNowPlayingInfo
{
    //更新锁屏时的歌曲信息
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:@"恋爱循环" forKey:MPMediaItemPropertyTitle];
        [dict setObject:@"花泽香菜" forKey:MPMediaItemPropertyArtist];
        [dict setObject:@"葫芦娃" forKey:MPMediaItemPropertyAlbumTitle];
        
        //UIImage *newImage = [UIImage imageNamed:@"dtspIcon"];
        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"Img_fenmian"]]
                 forKey:MPMediaItemPropertyArtwork];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}

/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
	if ([streamer isWaiting])
	{
        button.image = [UIImage imageNamed:@""];
        [button startSpin];
    } else if ([streamer isIdle]) {
        button.image = [UIImage imageNamed:playImage];
		[self stop];
        if (_delegate) {
            [_delegate bofangwc];
        }
	} else if ([streamer isPaused]) {
        button.image = [UIImage imageNamed:playImage];
        [button stopSpin];
        [button setColourR:0.0 G:0.0 B:0.0 A:0.0];
    } else if ([streamer isPlaying] || [streamer isFinishing]) {
        button.image = [UIImage imageNamed:stopImage];
        [button stopSpin];        
	} else {
        
    }
    
    [button setNeedsLayout];    
    [button setNeedsDisplay];
}


@end
