//
//  YZXImageURLSession.h
//  imageio
//
//  Created by 杨志新 on 16/7/5.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YZXImageSessionDelegate <NSObject>

- (void)sendImageData:(NSData *)data URL:(NSString *)url;

@end
@interface YZXImageURLSession : NSObject<NSURLSessionDelegate>

@property (nonatomic, strong) NSMutableData *recieveData;

@property (nonatomic, assign) id<YZXImageSessionDelegate> delegate;

- (void)initWithURL:(NSString *)imageURL;
@end
