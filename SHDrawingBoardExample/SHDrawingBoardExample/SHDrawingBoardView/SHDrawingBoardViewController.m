//
//  SHDrawingBoardViewController.m
//  SHDrawingBoardExample
//
//  Created by CSH on 2018/9/21.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHDrawingBoardViewController.h"
#import "SHDrawingBoardView.h"
#import "UIImageView+SHExtension.h"

@interface SHDrawingBoardViewController ()

//画板
@property (nonatomic, strong) SHDrawingBoardView *drawerView;
//画板工具
@property (nonatomic, strong) UIView *drawingTool;

//图片载体
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SHDrawingBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.editorImage) {
        CGRect frame = [self.imageView getImageFrame];
        self.imageView.frame = frame;
        self.drawerView.frame = frame;
    }else{
        
        self.drawerView.frame = self.drawingTool.frame;
    }
    
    [self.view addSubview:self.drawerView];
    [self.view addSubview:self.drawingTool];
}

#pragma mark 按钮点击
- (void)btnAction:(UIButton *)btn{
    
    switch (btn.tag) {
        case 1://取消
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 2://完成
        {
            //回调
            if (self.block) {
                
                
                if (!self.editorImage) {
                    
                    self.imageView.frame = self.drawerView.frame;
                }
                
                self.drawerView.frame = CGRectMake(0, 0, self.drawerView.frame.size.width, self.drawerView.frame.size.height);
                [self.imageView addSubview:self.drawerView];
                
                //截取视图
                UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
                
                [self.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
                
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                self.block(image);
            }
            
            //消失
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 10://清除
        {
            [self.drawerView drawingClean];
        }
            break;
        case 11://撤销
        {
            [self.drawerView drawingUndo];
        }
            break;
        default://颜色选取
        {
            //改变画笔颜色
            self.drawerView.lineColor = btn.backgroundColor;
            
            //修改样式
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            
            for (int i = 0; i < 6; i++) {
                UIButton *obj = [self.drawingTool viewWithTag:20 + i];
                
                if (obj.tag != btn.tag) {
                    obj.layer.borderColor = [UIColor clearColor].CGColor;
                }
            }
        }
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.drawerView touchesBegan:touches withEvent:event];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.drawingTool.alpha = 0;
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.drawerView touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.drawingTool.alpha = 1;
    }];
}

#pragma mark - 懒加载
- (UIView *)drawingTool{
    
    if (!_drawingTool) {
        
        _drawingTool = [[UIView alloc]init];
        _drawingTool.frame = self.view.bounds;
        _drawingTool.backgroundColor = [UIColor clearColor];
        _drawingTool.userInteractionEnabled = YES;
        
        CGFloat view_y = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat view_w = CGRectGetWidth(_drawingTool.frame);
        CGFloat view_h = CGRectGetHeight(_drawingTool.frame);
        
        //上方取消、完成
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(30 + i*(view_w - 60)/2, view_y, (view_w - 60)/2, 44);
            btn.tag = 1 + i;
            [btn setTitle:i?@"完成":@"取消" forState:0];
            btn.contentHorizontalAlignment = i?UIControlContentHorizontalAlignmentRight:UIControlContentHorizontalAlignmentLeft;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_drawingTool addSubview:btn];
        }
        
        //下方工具
        CGFloat view_x = (view_w/6 - 30)/2;
        //颜色选取
        for (int i = 0; i < 6; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(view_x, view_h - 30 - 60, 30, 30);
            view_x += CGRectGetWidth(self.view.frame)/6;
            btn.tag = 20 + i;
            
            btn.layer.borderColor = [UIColor clearColor].CGColor;
            btn.layer.borderWidth = 2;
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = YES;
            
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            switch (i) {
                case 0:
                {
                    btn.backgroundColor = [UIColor redColor];
                    [self btnAction:btn];
                }
                    break;
                case 1:
                    btn.backgroundColor = [UIColor orangeColor];
                    break;
                case 2:
                    btn.backgroundColor = [UIColor yellowColor];
                    break;
                case 3:
                    btn.backgroundColor = [UIColor greenColor];
                    break;
                case 4:
                    btn.backgroundColor = [UIColor blueColor];
                    break;
                case 5:
                    btn.backgroundColor = [UIColor purpleColor];
                    break;
                default:
                    break;
            }
            [_drawingTool addSubview:btn];
        }
        
        //下方操作按钮
        int num = 2;
        for (int i = 0; i < num; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i *view_w/num,view_h - 60 , view_w/num, 50);
            btn.tag = 10 + i;
            
            switch (i) {
                case 0:
                    [btn setTitle:@"清除" forState:0];
                    break;
                case 1:
                    [btn setTitle:@"撤销" forState:0];
                    break;
                default:
                    break;
            }
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_drawingTool addSubview:btn];
        }
    }
    
    return _drawingTool;
}

- (SHDrawingBoardView *)drawerView{
    
    if (!_drawerView) {
        _drawerView = [[SHDrawingBoardView alloc]init];
        _drawerView.backgroundColor = [UIColor clearColor];
    }
    return _drawerView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = self.view.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = self.editorImage;
        [self.view addSubview:self.imageView];
    }
    
    return _imageView;
}

#pragma mark 获取Size
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize size:(CGSize)size{
    
    if (MIN(size.width, size.height)) {
        
        if (size.width > size.height) {
            //宽大 按照宽给高
            CGFloat width = MIN(maxSize.width, size.height);
            return CGSizeMake(width, width*size.height/size.width);
        }else{
            //高大 按照高给宽
            CGFloat height = MIN(maxSize.height, size.height);
            return  CGSizeMake(height*size.width/size.height, height);
        }
    }
    
    return maxSize;
}

@end
