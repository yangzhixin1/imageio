//
//  YZXImageModel.m
//  imageio
//
//  Created by 杨志新 on 16/7/5.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import "YZXImageModel.h"

@implementation YZXImageModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ImageDate forKey:@"图片Data"];
    [aCoder encodeObject:self.StoreTime forKey:@"储存时间"];
  
}

#pragma mark 第二个协议方法:这个方法是在反归档时候会使用,把本地的数据重新读出来,并给相应的成员变量进行赋值

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        // 在判断里对对象的属性进行赋值
        // 两个方法中每个属性对应的key保持一致
        self.ImageDate = [aDecoder decodeObjectForKey:@"图片Data"];
        self.StoreTime = [aDecoder decodeObjectForKey:@"储存时间"];
        
    }
    return self;
}
@end
