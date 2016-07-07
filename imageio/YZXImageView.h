//
//  YZXImageView.h
//  imageio
//
//  Created by 杨志新 on 16/7/6.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZURLCache.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface YZXImageView : UIImageView <YZURLCacheDelegate>
@property(nonatomic, copy) NSString *imageUrl;
- (void)YZXCacheImaheFromURL:(NSString *)url ;
@end
