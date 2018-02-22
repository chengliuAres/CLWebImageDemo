//
//  CLImageManager.h
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLDownloadOperation.h"
typedef void(^CLloadImageCompletedBlock)(UIImage *image,NSData * data,NSError * error,BOOL finished,NSURL *imageUrl);

@interface CLImageManager : NSObject
+(instancetype)shareInstance;

-(CLDownloadOperation *)loadImageWithUrl:(NSString *)urlStr Completed:(CLloadImageCompletedBlock)completedBlock;
-(UIImage *)loadImageOnlyCache:(NSString *)url;
-(UIImage *)loadImageOnlyDisk:(NSString *)url;

-(void)clearCache;
-(void)clearDisk;
@end
