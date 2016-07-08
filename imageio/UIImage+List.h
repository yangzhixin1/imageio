//
//  UIImage+List.h
//  imageio
//
//  Created by 杨志新 on 16/6/29.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZURLCache.h"
typedef NS_ENUM(NSInteger, NSPUIImageType)

{ NSPUIImageType_JPEG,
    
    NSPUIImageType_PNG,
    
    NSPUIImageType_Unknown,
    NSPUIImageType_GIF,
    NSPUIImageType_JPG,
     NSPUIImageType_TIFF,
     NSPUIImageType_WEBP,
    
};

@interface UIImage (List)
+ (UIImage *)backImage:(NSData *)data;
+ (UIImage *)YZ_animatedGIFWithData:(NSData *)data;
+ (NSPUIImageType)contentTypeForImageData:(NSData *)data;//通过data 判断 图片格式
+ (UIImage *)judgeImageTypeHandle:(NSData *)data  success:(BackImageBlock) back;
@end
