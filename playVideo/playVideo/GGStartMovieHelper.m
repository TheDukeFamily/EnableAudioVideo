//
//  GGStartMovieHelper.m
//  playVideo
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "GGStartMovieHelper.h"
#import "GGStartMovieView.h"

@interface GGStartMovieHelper ()

@property (weak, nonatomic) UIWindow *curwindow;

@property (strong, nonatomic) GGStartMovieView *startMovieView;

@end

@implementation GGStartMovieHelper

static GGStartMovieHelper *shareInstance_ = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance_ = [[GGStartMovieHelper alloc] init];
    });
    return shareInstance_;
}

+ (void)showStartMovieWithURL:(NSURL *)URL{
    if (![GGStartMovieHelper shareInstance].startMovieView) {
        
        GGStartMovieView *startMovieView = [GGStartMovieView movieView];
        startMovieView.movieURL = URL;
        [GGStartMovieHelper shareInstance].startMovieView = startMovieView;
        
    }
    
    [GGStartMovieHelper shareInstance].curwindow = [UIApplication sharedApplication].keyWindow;
    [[GGStartMovieHelper shareInstance].curwindow addSubview:[GGStartMovieHelper shareInstance].startMovieView];
}

@end
