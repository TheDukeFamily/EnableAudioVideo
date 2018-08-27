//
//  GGStartMovieHelper.h
//  playVideo
//
//  Created by Mac on 2018/6/11.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGStartMovieHelper : NSObject

+ (instancetype)shareInstance;

+ (void)showStartMovieWithURL:(NSURL *)URL;

@end
