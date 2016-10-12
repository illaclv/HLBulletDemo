//
//  BulletView.h
//  HLBulletDemo
//
//  Created by 隆大佶 on 16/8/31.
//  Copyright © 2016年 HangLong Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,moveStatus){
    start,
    enter,
    end
};

@interface BulletView : UIView

@property(nonatomic,assign)int trajectory;//弹道
@property(nonatomic,copy)void(^moveStatusBlock)(moveStatus);//弹幕状态的回调

-(instancetype)initWithComment:(NSString *)comment;

-(void)startAnimation;

-(void)stopAnimation;


@end
