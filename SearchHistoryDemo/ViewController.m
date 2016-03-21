//
//  ViewController.m
//  SearchHistoryDemo
//
//  Created by Lzq on 16/3/6.
//  Copyright © 2016年 Lzq. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
@interface ViewController ()
- (IBAction)pushSearchVC:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushSearchVC:(UIButton *)sender {
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    UINavigationController *searchNavc = [[UINavigationController alloc]initWithRootViewController:searchVC];
    [self presentViewController:searchNavc animated:YES completion:nil];
}
@end
