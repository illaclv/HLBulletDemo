//
//  BulletManager.m
//  HLBulletDemo
//
//  Created by 隆大佶 on 16/8/31.
//  Copyright © 2016年 HangLong Lv. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"
@interface BulletManager()
@property(nonatomic,strong)NSMutableArray *datasource;

@property(nonatomic,strong)NSMutableArray *bulletComments;

//存储弹幕view 的数组
@property(nonatomic,strong)NSMutableArray *bulletViews;

@property BOOL bStopA;

@end

@implementation BulletManager
-(instancetype)init{
    if (self = [super init]) {
        self.bStopA = YES;
    }
    return  self;
}

-(void)start{
    if (!self.bStopA) {
        return;
    }
    self.bStopA = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.datasource];
    
    [self initBulletComment];
}
-(void)stop{
    if (self.bStopA ) {
        return;
    }
    self.bStopA = YES;
    
    //停止
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

//初始化弹幕，随机分配弹幕轨迹
-(void)initBulletComment{
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i ++ ) {
        if (self.bulletComments.count > 0) {
            ///通过随机数获取弹幕轨迹
            NSInteger index = arc4random()%trajectorys.count;
            long trajectory = [[trajectorys objectAtIndex:index]integerValue];
            [trajectorys removeObjectAtIndex:index];
            //从弹幕数组逐一取出数据
            NSString *comment = [self.bulletComments firstObject];
            
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self creatBulletView:comment trajectory:trajectory];
        }
       
    }
    
}

-(void)creatBulletView:(NSString *)comment trajectory:(long)trajectory{
    
    if(self.bStopA){
        return;
    }
    
    BulletView *view = [[BulletView alloc]initWithComment:comment];
    view.trajectory = (int)trajectory;
    [self.bulletViews addObject:view];
    __weak typeof (view) weakView = view;
    __weak typeof (self) weakSelf = self;

    view.moveStatusBlock = ^(moveStatus status){
        if(self.bStopA){
            return;
        }

        switch (status) {
            case start:{
//                弹幕开始进入屏幕，将view加入弹幕管理数组bulletComments
                [weakSelf.bulletViews addObject:weakView];
                break;

            }
                
            case enter:{
//弹幕完全进入屏幕，判断是否还有其他内容，如果有则在弹幕轨迹中，则再创建一个弹幕
                NSString * comment = [weakSelf nextComment];
                if (comment) {
                    [weakSelf creatBulletView:comment trajectory:trajectory];
                }
                break;

                }
                
            case end:{
//                    弹幕完全废除屏幕后，从bullentview删除，释放资源
                if([weakSelf.bulletViews containsObject:weakView]){
                    //        移除屏幕 并销毁
                    [weakView stopAnimation];
                    [weakSelf.bulletViews removeObject:weakView];
                }
                if (weakSelf.bulletViews.count == 0) {
//                    屏幕没有弹幕，开始循环滚动
                    self.bStopA = YES;
                    [weakSelf start];
                }
                break;

                }
                
                
            default:
                break;
        }
        

    };

    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}
-(NSString *)nextComment{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    
     NSString * comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;

}

-(NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithArray:@[@"1111111111",
                                                       @"22222",
                                                       @"3333333333333333333333",
                                                       @"4444444",
                                                       @"555555555555555",
                                                       @"666666666666666666666666666",
                                                       @"1111111111",
                                                       @"22222",
                                                       @"444444444"]];
    }
    return _datasource;
}

-(NSMutableArray *)bulletComments{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}
-(NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}
@end
