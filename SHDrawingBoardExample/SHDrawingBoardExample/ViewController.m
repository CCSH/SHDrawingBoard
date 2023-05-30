//
//  ViewController.m
//  SHDrawingBoardExample
//
//  Created by CSH on 2018/9/21.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHDrawingBoardViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SHDrawingBoardViewController *vc = [[SHDrawingBoardViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.editorImage = [UIImage imageNamed:@"all_task_message"];
    vc.block = ^(UIImage * _Nonnull image) {
        
    };
    [self presentViewController:vc animated:YES completion:nil];
}


@end
