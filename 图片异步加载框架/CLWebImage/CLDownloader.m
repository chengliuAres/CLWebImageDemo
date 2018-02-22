//
//  CLDownloader.m
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "CLDownloader.h"
@interface CLDownloader()
@property (nonatomic,strong) NSURLSession * session;
@property (nonatomic,strong) NSFileManager * fileManager;
@property (nonatomic,copy) NSString * photoCachePath;
@property (nonatomic,strong) NSMutableDictionary * progressDic;
@end
@implementation CLDownloader
static CLDownloader * downLoader = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!downLoader) {
            downLoader = [[CLDownloader alloc] init];
            downLoader.fileManager = [NSFileManager defaultManager];
            NSString * PhotoCache = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/PhotoCaches"];
            if (![downLoader.fileManager fileExistsAtPath:PhotoCache]) {
                [downLoader.fileManager createDirectoryAtPath:PhotoCache withIntermediateDirectories:YES attributes:nil error:nil];
            }
            downLoader.photoCachePath = PhotoCache;
            downLoader.progressDic = [NSMutableDictionary dictionary];
            NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
            downLoader.session =[NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        }
    });
    return downLoader;
}

-(CLDownloadOperation *)downloadImageWithUrl:(NSURL *)url CompletedBlock:(CLDownImageCompletedBlock)completedBlock{
    CLDownloadOperation * operation = [CLDownloadOperation new];
    operation.operationID = url.absoluteString;
    NSURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    NSURLSessionDownloadTask * task = [self.session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData * data = [NSData dataWithContentsOfURL:location];
            operation.imageData = data;
            completedBlock(data,nil,YES);
        }else{
            completedBlock(nil,error,YES);
        }
    }];
    [task resume];
    return operation;
}

@end
