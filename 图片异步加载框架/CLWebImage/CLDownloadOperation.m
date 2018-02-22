//
//  CLDownloadOperation.m
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "CLDownloadOperation.h"

@implementation CLDownloadOperation

-(instancetype)init{
    self = [super init];
    _isCancelled = NO;
    return self;
}
/** 发送图片下载完毕的通知，便于有多个控件同时设置相同的图片*/
-(void)setImageData:(NSData *)imageData{
    _imageData = imageData;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reReadImageAfterDownload" object:nil userInfo:@{@"url":_operationID,@"data":_imageData}];
}

-(void)cancelDownload{
    @synchronized(self){
        if (!_isCancelled) {
            _isCancelled = YES;
        }
    }
}

@end
