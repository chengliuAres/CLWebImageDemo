//
//  ViewController.m
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/13.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController1.h"
#import "CLImageManager.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)clear:(id)sender {
    [CLImageManager.shareInstance clearCache];
    [CLImageManager.shareInstance clearDisk];
    NSLog(@"清除缓存");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击页面";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    TableViewController1 * table = [TableViewController1 new];
    [self.navigationController pushViewController:table animated:YES];
}

@end
