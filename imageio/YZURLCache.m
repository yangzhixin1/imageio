//
//  YZURLCache.m
//  imageio
//
//  Created by 杨志新 on 16/6/22.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import "UIImage+List.h"
#import "YZURLCache.h"
#import "YZXImageModel.h"
#import "YZXImageURLSession.h"
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YZURLCache () <YZXImageSessionDelegate>
@property(nonatomic, strong) NSCache *tempCach; //内存缓存

@property(nonatomic, copy) NSString *filename;  //图片硬盘路径
@property(nonatomic, strong) NSFileManager *fm; //文件控制器

@end

@implementation YZURLCache
+ (instancetype)shareCache {
  static YZURLCache *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [self new];

  });
  return instance;
}

- (id)init {
  self = [super init];
  if (self) {
    _tempCach = [[NSCache alloc] init];

    NSArray *pathcaches = NSSearchPathForDirectoriesInDomains(
        NSCachesDirectory, NSUserDomainMask, YES);

    NSString *path = [pathcaches objectAtIndex:0];

    _filename = [path stringByAppendingPathComponent:@"YZX.image.plist"];
    _fm = [NSFileManager defaultManager];
    [self isHadManagerFile];
  }
  return self;
}
- (void)setDate:(NSData *)data key:(NSString *)url {

  YZXImageModel *imageModel = [[YZXImageModel alloc] init];
  imageModel.ImageDate = data;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyyMMddHHmmss"];
  NSString *currentTime = [formatter stringFromDate:[NSDate date]];
  imageModel.StoreTime = currentTime;
  [_tempCach setObject:[NSDictionary dictionaryWithObjectsAndKeys:data, url,
                                                                  currentTime,
                                                                  @"time", nil]
                forKey:url];
}
- (BOOL) isTempCache:(NSString *)url {
    if ([_tempCach objectForKey:url]) {
        return YES;
    } else {
        return NO;
    }
    
}
- (void)isHadManagerFile {
  if ([_fm fileExistsAtPath:_filename]) {
    NSLog(@"文件已存在%@",_filename);

  } else {
    [_fm createFileAtPath:_filename contents:nil attributes:nil];
  }
}
#pragma mark *******判断内存是否缓存图片
- (UIImage *)isCachHad:(NSString *)url success:(BackImageBlock)success {
   
    __block UIImage *fromImage = [UIImage new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self isTempCache:url]) {
            NSLog(@"Cache存在");
            
            fromImage = [self getCacheData:url];
        } else if ([self isDiskHad:url]) {
            NSLog(@"%@", @"硬盘存在");
            fromImage =  [self getDiskStoreDate:url];
            
        } else {
            /**
             *  可以添加解析层
             */
            YZXImageURLSession *session = [[YZXImageURLSession alloc] init];
            session.delegate = self;
            [session initWithURL:url];
            
            fromImage = nil;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            success(fromImage);
        });
    });

    return nil;
     //判断层内存是否已有图片缓存
  }

- (BOOL)isDiskHad:(NSString *)url {
  NSArray *pathcaches = NSSearchPathForDirectoriesInDomains(
      NSCachesDirectory, NSUserDomainMask, YES);

  NSString *path = [pathcaches objectAtIndex:0];

  NSString *filename = [path stringByAppendingPathComponent:@"YZX.image.plist"];
  NSDictionary *imagesDic =
      [NSDictionary dictionaryWithContentsOfFile:filename];
  if ([imagesDic objectForKey:url]) {
    return YES;
  }
  return NO;
}
#pragma mark *******if 存在返回数据
- (UIImage *)getCacheData:(NSString *)url {

  @autoreleasepool {
  UIImage *newImage = [UIImage
      judgeImageTypeHandle:[[_tempCach objectForKey:url] objectForKey:url]];
  return newImage;
  }
}

#pragma mark ******** 进行沙盒存储

- (void)greateDiskStoreDate:(NSData *)data key:(NSString *)url {

  
  YZXImageModel *imageModel = [[YZXImageModel alloc] init];
  imageModel.ImageDate = data;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyyMMddHHmmss"];
  NSString *currentTime = [formatter stringFromDate:[NSDate date]];
  imageModel.StoreTime = currentTime;
  NSMutableDictionary *fileDic = [NSMutableDictionary
      dictionaryWithDictionary:[NSDictionary
                                   dictionaryWithContentsOfFile:_filename]];

  NSDictionary *dic = [NSDictionary
      dictionaryWithObjectsAndKeys:data, url, currentTime, @"time", nil];
  [fileDic setObject:dic forKey:url];
  [fileDic writeToFile:_filename atomically:YES];
    
}

#pragma mark *********cach文件中取出图片.(返回data)

- (UIImage *)getDiskStoreDate:(NSString *)url {

  NSDictionary *imagesDic =
      [NSDictionary dictionaryWithContentsOfFile:_filename];
  
  // YZXImageModel *imageModel = [imagesDic objectForKey:url];
    @autoreleasepool {
  UIImage *newImage = [UIImage
      judgeImageTypeHandle:[[imagesDic objectForKey:url] objectForKey:url]];
    [self setDate:[[imagesDic objectForKey:url] objectForKey:url] key:url];
  return newImage;
    }
}
#pragma mark ***********session 协议方法

- (void)sendImageData:(NSData *)data URL:(NSString *)url {
 // [self setDate:data key:url];
  [self greateDiskStoreDate:data key:url];

  UIImage *NewImage = [UIImage judgeImageTypeHandle:data];
  

  NSNotification *notification = [NSNotification
      notificationWithName:@"CHANGEUI"
                    object:self
                  userInfo:[NSDictionary
                               dictionaryWithObjectsAndKeys:url, @"imageURL",
                                                            NewImage, @"image",
                                                            nil]];

  [[NSNotificationCenter defaultCenter]
      performSelectorOnMainThread:@selector(postNotification:)
                       withObject:notification
                    waitUntilDone:YES];

  //[self.delagete sendImage:NewImage URL:url];
}

@end
