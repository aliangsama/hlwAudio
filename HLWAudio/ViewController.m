//
//  ViewController.m
//  HLWAudio
//
//  Created by 黄黎雯 on 2017/8/7.
//  Copyright © 2017年 Drugdisc. All rights reserved.
//

#import "ViewController.h"
#import "AudioButton.h"
#import "AudioPlayer.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
//包括状态栏的屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//适配的导航栏高度
#define TITLE_BAR_HEIGHT 64
@interface ViewController ()<AudioPlayerDelegate>{
    AudioPlayer *_audioPlayer;
    UIImageView*navBarHairlineImageView;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (weak, nonatomic) IBOutlet UIImageView *imagefm;
@property (weak, nonatomic) IBOutlet UILabel *labtime;
@property (weak, nonatomic) IBOutlet UIView *viewfm;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labZhubo;
@property (weak, nonatomic) IBOutlet UILabel *labLikeST;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIView *viewfmBg;

@property (strong, nonatomic) IBOutlet AudioButton *audioButton;

@property(nonatomic,assign)BOOL isplay;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0-40, 0, 80, TITLE_BAR_HEIGHT)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"音乐播放";
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    CGRect frame=[_viewContent frame];
    frame.origin.y=(SCREEN_HEIGHT-184)/2-frame.size.height/2+64;
    _viewContent.frame=frame;
    
    _isplay=YES;
    
    _viewfmBg.layer.cornerRadius = _viewfmBg.frame.size.height/2;
    _viewfmBg.clipsToBounds = YES;
    _imagefm.layer.cornerRadius = _imagefm.frame.size.height/2;
    _imagefm.clipsToBounds = YES;
    self.audioButton = [[AudioButton alloc] initWithFrame:CGRectMake(1, 1, 172, 172)];
    [self.audioButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [_viewfm addSubview:_audioButton];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_imageBg addSubview:effectview];
    
    [self setContent];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        
        if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [_audioPlayer ycstop];
        }else if(event.subtype == UIEventSubtypeRemoteControlPlay){
            [_audioPlayer ycplay];
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            [_audioPlayer stop];
            //下一首
        }else if (event.subtype==UIEventSubtypeRemoteControlPreviousTrack){
            [_audioPlayer stop];
            //上一首
        }
        
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
        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[self getImageFromURL:@"https://gss1.bdstatic.com/-vo3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=3f5be40f7b8da9774e2f812d886a9f24/a6efce1b9d16fdfada9ae1d2bc8f8c5494ee7b13.jpg"]]
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

- (UIImageView*)findHairlineImageViewUnder:(UIView*)view {
    
    if([view isKindOfClass:UIImageView.class] && view.bounds.size.height<=1.0) {
        return(UIImageView*)view;
    }
    for(UIView*subview in view.subviews) {
        UIImageView*imageView = [self findHairlineImageViewUnder:subview];
        if(imageView) {
            return imageView;
        }
    }
    return nil;
}

-(void)setContent{
    [_imageBg setImage:[UIImage imageNamed:@"Img_fenmian"]];
    [_imagefm setImage:[UIImage imageNamed:@"Img_fenmian"]];
    
    _labTitle.text=@"恋爱循环";
    _labTitle.numberOfLines=0;
    _labTitle.lineBreakMode=NSLineBreakByCharWrapping;
    _labZhubo.text=@"主播：花泽香菜/钉宫理惠";
    _labLikeST.text=@"喜欢：11   收听：1111";

        [_btnLike setImage:[UIImage imageNamed:@"dtLoveIcon_N"] forState:UIControlStateNormal];
    
    [self setLockScreenNowPlayingInfo];
    
    [self playAudio];
}

-(void)playAudio{
    if (_audioPlayer == nil) {
        _audioPlayer = [AudioPlayer getInstance];
        _audioPlayer.delegate=self;
    }
    _audioPlayer.button = _audioButton;
    _audioPlayer.url = [NSURL URLWithString:@"http://music.163.com/song/media/outer/url?id=34609107.mp3"];
    [_audioPlayer play];
    
}

-(void)action:(id)sender{
    _isplay=!_isplay;
    [_audioPlayer play];
}

//委托
-(void)bofangwc{
    [_audioPlayer stop];
}

-(void)bofangstop{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (IBAction)onNextPlay:(id)sender {
    [_audioPlayer stop];
}

- (IBAction)onLike:(id)sender {
}

- (IBAction)onShare:(id)sender {
}
@end
