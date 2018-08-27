//
//  GGStartMovieView.m
//  playVideo
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGStartMovieView.h"
#import "UIImage+LaunchImage.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


@interface AnimationDelegate : NSObject  <CAAnimationDelegate>

@property (nonatomic, strong) AVPlayer *animationDelegatePlayer;

@end

@implementation AnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.animationDelegatePlayer play];
}

@end


@interface GGStartMovieView ()
@property (nonatomic, weak) UIButton * endButton;
@property (nonatomic, weak) AVPlayer *player;
@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) CABasicAnimation *scaleAnimation;//这东西只能强引用

@property (nonatomic, strong) AVAudioPlayer *musicPlayer;//音乐播放
@end

@implementation GGStartMovieView

+ (instancetype)movieView{
    GGStartMovieView *movieView = [[GGStartMovieView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return movieView;
}

- (void)setMovieURL:(NSURL *)movieURL{
    
    _movieURL = movieURL;
    
    CALayer *backLayer = [CALayer layer];
    backLayer.frame = [UIScreen mainScreen].bounds;
    backLayer.contents = (__bridge id _Nullable)[UIImage getLaunchImage].CGImage;
    [self.layer addSublayer:backLayer];
    
    
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:movieURL];
    
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    player.volume = 0;
    player.volume = 3.0f;
    self.player = player;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    playerLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer addSublayer:playerLayer];
    self.playerLayer = playerLayer;
    ;
    
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"welcome_2_0.mp3" withExtension:nil] error:nil];
    self.musicPlayer.numberOfLoops = -1;
    [self.musicPlayer setVolume:1.0];
    [self.musicPlayer prepareToPlay];
    [self.musicPlayer play];
    
    
    
//    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"welcome_2_0.mp3" withExtension:nil] error:nil];
//    // 3.准备播放 (音乐播放的内存空间的开辟等功能)  不写这行代码直接播放也会默认调用prepareToPlay
//    self.musicPlayer.numberOfLoops = -1;
//    [self.musicPlayer setVolume:1.0];
//    [self.musicPlayer prepareToPlay];
//    [self.musicPlayer play];
//    self.musicPlayer = musicPlayer;
    
    UIButton *endButton = [[UIButton alloc] init];
    endButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/3, [UIScreen mainScreen].bounds.size.height-130, [UIScreen mainScreen].bounds.size.width/3, 50);
    endButton.backgroundColor = [UIColor redColor];
    endButton.layer.borderWidth = 1;
    endButton.layer.cornerRadius = 24;
    endButton.layer.borderColor = [UIColor redColor].CGColor;
    [endButton setTitle:@"开启旅程" forState:UIControlStateNormal];
    [endButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    endButton.alpha = 0.0;
    [endButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endButton];
    self.endButton = endButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.0];//设定动画的开始帧
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];//设定动画的完成帧
    scaleAnimation.duration = 1.0f;//动画时长
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//设定动画的速度变化
    self.scaleAnimation = scaleAnimation;

    AnimationDelegate *animationDelegate = [AnimationDelegate new];
    animationDelegate.animationDelegatePlayer = self.player;
    scaleAnimation.delegate = animationDelegate;
    [self.playerLayer addAnimation:scaleAnimation forKey:nil];
    [UIView animateWithDuration:2.0 animations:^{
        self.endButton.alpha = 1.0;
    }];
}

- (void)playbackFinished:(NSNotification *)notifation {
    if (self.player.currentItem == notifation.object) {
        // 回到视频的播放起点
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }else if (self.musicPlayer == notifation.object){
        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    }
    
    
}

- (void)removeFromSuperview{
    [self.player pause];
    [self.musicPlayer pause];
    self.musicPlayer = nil;
    self.player = nil;
    self.playerLayer = nil;
    self.scaleAnimation.delegate = nil;
    self.scaleAnimation = nil;
    self.endButton = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

- (void)enterMainAction:(UIButton *)button{
    [self removeFromSuperview];
}

@end


