//
//  SHDrawingBoardViewController.h
//  SHDrawingBoardExample
//
//  Created by CSH on 2018/9/21.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  图片编辑界面
 */

//编辑完成图片回调
typedef void(^SHGraffitiEditorBlock)(UIImage *image);

@interface SHDrawingBoardViewController : UIViewController

//需要编辑的图片(nil的话就是画板)
@property (nonatomic, strong) UIImage *editorImage;
//回调
@property (nonatomic, copy) SHGraffitiEditorBlock block;

@end

NS_ASSUME_NONNULL_END
