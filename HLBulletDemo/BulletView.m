//
//  BulletView.m
//  HLBulletDemo
//
//  Created by 隆大佶 on 16/8/31.
//  Copyright © 2016年 HangLong Lv. All rights reserved.
//
#define padding 10
#define photoHeight 30

#import "BulletView.h"
@interface BulletView()
//弹幕的laberl
@property(nonatomic,strong)UILabel *lbComment;

@property(nonatomic,strong)UIImageView *photoImage;

@end

@implementation BulletView

//初始化
-(instancetype)initWithComment:(NSString *)comment{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 15;
        
        NSDictionary *sttr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:sttr].width;
        self.bounds = CGRectMake(0, 0, width + 2 * padding +photoHeight, 30);
        self.lbComment.frame = CGRectMake(padding+ photoHeight, 0, width, 30);
        self.lbComment.text = comment;
        
        
        self.photoImage.frame = CGRectMake(-padding, -padding, photoHeight+padding, photoHeight+padding);
        self.photoImage.layer.cornerRadius = (photoHeight+padding)*0.5;
        self.photoImage.layer.borderColor = [UIColor orangeColor].CGColor;
        self.photoImage.layer.borderWidth = 0.5;
        self.photoImage.image = [UIImage imageNamed:@"hah.png"];
    }
    return self;
}

-(void)startAnimation{
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWith +CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(start);
    }
    CGFloat speed = wholeWidth/4.0;
    CGFloat enterDuration = self.bounds.size.width/speed;
//延迟
 
    [self performSelector:@selector(EnterScreen) withObject:nil afterDelay:enterDuration ] ;

    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.moveStatusBlock) {
//            self.moveStatusBlock(enter);
//        }
// 
//    });
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatusBlock) {
            self.moveStatusBlock(end);
        }
    }];
    
}
-(void)EnterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(enter);
    }
}

-(void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

-(UILabel *)lbComment{
    if (!_lbComment) {
        _lbComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];

    }
    return _lbComment;
}

-(UIImageView *)photoImage{
    if (!_photoImage) {
        _photoImage = [UIImageView new];
        _photoImage.clipsToBounds = YES;
        _photoImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_photoImage];
        
    }
    return _photoImage;

}

@end
