//
//  YZURLCache.h
//  imageio
//
//  Created by 杨志新 on 16/6/22.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^BackImageBlock)(UIImage *image);
@protocol YZURLCacheDelegate <NSObject>
#pragma mark 加载数据完毕 更新UI
- (void)sendImage:(UIImage *)image URL:(NSString *)url;

@end

@interface YZURLCache : NSObject
@property(nonatomic, assign) id<YZURLCacheDelegate>delagete;

+ (instancetype)shareCache;
- (void)setDate:(NSData *)data key:(NSString *)url;
- (UIImage *)isCachHad:(NSString *)url success:(BackImageBlock)success;
- (UIImage *)getCacheData:(NSString *)url;
- (void)greateDiskStoreDate:(NSData *)data key:(NSString *)url;
- (UIImage *)getDiskStoreDate:(NSString *)url;

@end
