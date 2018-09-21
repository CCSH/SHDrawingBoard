//
//  SHDrawingBoardView.h
//  SHDrawingBoardExample
//
//  Created by CSH on 2018/9/21.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 画板视图
 */
@interface SHDrawingBoardView : UIView

//画笔颜色(默认黑色)
@property (nonatomic, strong) UIColor *lineColor;
//画笔粗细（默认5）
@property (nonatomic, assign) CGFloat lineWidth;

//清除
- (void)drawingClean;
//撤销
- (void)drawingUndo;

@end

NS_ASSUME_NONNULL_END
