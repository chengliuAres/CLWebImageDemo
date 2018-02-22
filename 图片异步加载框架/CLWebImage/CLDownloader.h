//
//  CLDownloader.h
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLDownloadOperation.h"
typedef void(^CLDownImageCompletedBlock)(NSData * data, NSError * error, BOOL finished);
typedef void(^CLDownImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

@interface CLDownloader : NSObject
+(instancetype)shareInstance;

-(CLDownloadOperation *)downloadImageWithUrl:(NSURL *)url CompletedBlock:(CLDownImageCompletedBlock)completedBlock;
@end
