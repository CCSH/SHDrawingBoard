//
//  SHDrawingBoardView.m
//  SHDrawingBoardExample
//
//  Created by CSH on 2018/9/21.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHDrawingBoardView.h"

@interface SHDrawingBoardView ()

//用来管理画板上所有的路径
@property(nonatomic,strong) NSMutableArray *paths;

@end

@implementation SHDrawingBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private methods
- (void)setup {
    
    self.userInteractionEnabled = YES;
    
    _lineColor = [UIColor blackColor];
}

#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 获取触摸对象
    UITouch *touch = [touches anyObject];
    // 获取手指的位置
    CGPoint point = [touch locationInView:touch.view];
    point = CGPointMake(point.x - self.frame.origin.x, point.y - self.frame.origin.y);
    
    //当手指按下的时候就创建一条路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //设置画笔宽度
    if(self.lineWidth){
        [path setLineWidth:self.lineWidth];
        
    }else{
        [path setLineWidth:5];
    }
    //设置起点
    [path moveToPoint:point];
    // 把每一次新创建的路径 添加到数组当中
    NSDictionary *dic = @{@"color":self.lineColor,
                          @"path":path};
    
    [self.paths addObject:dic];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // 获取触摸对象
    UITouch *touch = [touches anyObject];
    // 获取手指的位置
    CGPoint point = [touch locationInView:touch.view];
    point = CGPointMake(point.x - self.frame.origin.x, point.y - self.frame.origin.y);
    
    // 连线的点
    NSDictionary *dic = [self.paths lastObject];
    [dic[@"path"] addLineToPoint:point];
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    for (NSDictionary *obj in self.paths) {
        
        UIColor *color = obj[@"color"];
        UIBezierPath *path = obj[@"path"];
        
        //设置颜色
        [color set];
        // 设置连接处的样式
        [path setLineJoinStyle:kCGLineJoinRound];
        // 设置头尾的样式
        [path setLineCapStyle:kCGLineCapRound];
        //渲染
        [path stroke];
    }
}

#pragma mark - 公共方法
#pragma mark 清除
- (void)drawingClean{
    [self.paths removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}
#pragma mark 撤销
- (void)drawingUndo{
    [self.paths removeLastObject];
    //重绘
    [self setNeedsDisplay];
}

#pragma mark - 懒加载
- (NSMutableArray *)paths{
    if (!_paths) {
        _paths = [[NSMutableArray alloc]init];
    }
    return _paths;
}

@end
