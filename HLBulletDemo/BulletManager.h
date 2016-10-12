//
//  BulletManager.h
//  HLBulletDemo
//
//  Created by 隆大佶 on 16/8/31.
//  Copyright © 2016年 HangLong Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BulletView;
@interface BulletManager : NSObject

@property(nonatomic,copy)void(^generateViewBlock)(BulletView *view);

-(void)start;

-(void)stop;

@end
