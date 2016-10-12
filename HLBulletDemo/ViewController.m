//
//  ViewController.m
//  HLBulletDemo
//
//  Created by 隆大佶 on 16/8/31.
//  Copyright © 2016年 HangLong Lv. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulletView.h"
@interface ViewController ()
@property(nonatomic,strong)BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [[BulletManager alloc]init];
    __weak typeof(self)myself = self;

    self.manager.generateViewBlock = ^(BulletView * view){
        [myself addBulletView:view];
    };
    
    
    
    UIButton *but = [UIButton buttonWithType: UIButtonTypeCustom];
    [but setTitle:@"start" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    but.frame = CGRectMake(100, 100, 100, 40);
    [self.view addSubview:but];
    [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *but2 = [UIButton buttonWithType: UIButtonTypeCustom];
    [but2 setTitle:@"stop" forState:UIControlStateNormal];
    [but2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    but2.frame = CGRectMake(200, 100, 100, 40);
    [self.view addSubview:but2];
    [but2 addTarget:self action:@selector(butAction2:) forControlEvents:UIControlEventTouchUpInside];

  
    
}
-(void)butAction:(UIButton *)sender{
    [self.manager start];
}
-(void)butAction2:(UIButton *)sender{
    [self.manager stop];
}

-(void)addBulletView:(BulletView *)view{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300+view.trajectory * 50, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    
    [view startAnimation];
}

@end
