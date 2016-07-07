//
//  ImageCellTableViewCell.m
//  imageio
//
//  Created by 杨志新 on 16/7/7.
//  Copyright © 2016年 杨志新. All rights reserved.
//

#import "ImageCellTableViewCell.h"

@implementation ImageCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _testImage.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
