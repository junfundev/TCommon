//
//  PhotoManager.h
//  News
//
//  Created by junFung on 15/11/5.
//  Copyright © 2015年 yc. All rights reserved.
//
typedef NS_ENUM(NSInteger,ImagePickerViewControllerSourceType) {
    ImagePickerViewControllerCamera = 0,
    ImagePickerViewControllerPhotoLibrary ,
};

#import <Foundation/Foundation.h>

@interface PhotoManager : NSObject
/**
 *  照片选择器
 *
 *  @param complete 结束后的回调
 */
+ (void)chooseImage:(UIViewController *)viewController
      completeBlock:(void(^)(UIImage *image,id infoDict))complete;

/**
 *  类方法创建一个 actionSheet 的实例
 *
 *  @param title                  标题
 *  @param cancelButtonTitle      取消按钮
 *  @param destructiveButtonTitle 删除或者红色按钮的标题
 *  @param otherButtonTitles      其他按钮 可以有多个 必须放数组里边
 *  @param view                   显示是视图 不存在加载到 window 上边
 *  @param comBlcok               点击了按钮后的回调
 *
 *  @return 返回一个 actionSheet 的单例
 */
+ (instancetype)showActionSheetForPickImageWithTitle:(NSString *)title
                                   cancelButtonTitle:(NSString *)cancelButtonTitle
                              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                                   otherButtonTitles:(NSArray *)otherButtonTitles
                                          showInView:(UIView*)view
                                            completeBlock:(void(^)(NSInteger buttonIndex))completeBlcok;
/**
 *  completeBlock
 */
@property (nonatomic, copy)void(^completeBlock)(NSInteger index);
/**
 *  选择照相机和相册后的回调
 */
@property(nonatomic,copy)void(^imagePickComplete)(UIImage*image,NSDictionary *info);

@end
