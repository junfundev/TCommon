//
//  PhotoManager.m
//  News
//
//  Created by junFung on 15/11/5.
//  Copyright © 2015年 yc. All rights reserved.
//

#import "PhotoManager.h"

@interface PhotoManager ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PhotoManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static PhotoManager *manager;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (instancetype)manager
{
    return [[super alloc] init];
}

+ (void)chooseImage:(UIViewController *)viewController completeBlock:(void(^)(UIImage *image,id infoDict))complete
{
    [PhotoManager showActionSheetForPickImageWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择",@"拍照"] showInView:nil completeBlock:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {//相册
            [PhotoManager showImagePickerViewControllerInViewControler:viewController sourceType:ImagePickerViewControllerPhotoLibrary completeBlock:^(UIImage *image, id infoDict) {
                if (complete) {
                    complete(image,infoDict);
                }
            }];
        }
        if (buttonIndex == 2) {//相机
            [PhotoManager showImagePickerViewControllerInViewControler:viewController sourceType:ImagePickerViewControllerCamera completeBlock:^(UIImage *image, id infoDict) {
                if (complete) {
                    complete(image,infoDict);
                }
            }];
        }
    }];
}

+ (instancetype)showActionSheetForPickImageWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles showInView:(UIView *)view completeBlock:(void (^)(NSInteger))completeBlock
{
    PhotoManager *manager = [PhotoManager manager];
    manager.completeBlock = completeBlock;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:manager cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil, nil];
    
    for (NSString *otherTitle in otherButtonTitles) {
        [actionSheet addButtonWithTitle:otherTitle];
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    if (view==nil) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    [actionSheet showInView:view];
    
    return manager;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completeBlock) {
        self.completeBlock(buttonIndex);
    }
}

#pragma mark --- 照片选择 ---
+ (void)showImagePickerViewControllerInViewControler:(UIViewController*)viewController sourceType:(ImagePickerViewControllerSourceType)type completeBlock:(void(^)(UIImage *image,id infoDict))complete
{
    PhotoManager *showView = [PhotoManager manager];
    
    UIImagePickerControllerSourceType sourceType = 0;
    if (type == ImagePickerViewControllerCamera) {
        
        BOOL isCameraSupport = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (!isCameraSupport) {
            NSLog(@"无法打开摄像头，请先检查设备");
            return;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    UIImagePickerController *pic = [[UIImagePickerController alloc] init];
    if (type == ImagePickerViewControllerPhotoLibrary) {
        sourceType            =UIImagePickerControllerSourceTypePhotoLibrary;
    }
    pic.sourceType               = sourceType;
    pic.delegate                 = showView;
    pic.allowsEditing = YES;
    [viewController presentViewController:pic animated:YES completion:nil];
    showView.imagePickComplete   = complete;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[@"UIImagePickerControllerEditedImage"];
        if (weakSelf.imagePickComplete) {
            weakSelf.imagePickComplete(image,info);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.imagePickComplete) {
            weakSelf.imagePickComplete(nil,nil);
        }
    }];
}
@end
