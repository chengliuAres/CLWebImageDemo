//
//  CLDownloadOperation.h
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLDownloadOperation : NSObject
@property (nonatomic,copy) NSString * operationID;
@property (nonatomic,assign) BOOL isCancelled;
@property (nonatomic,strong) NSData * imageData;

-(void)cancelDownload;
@end
