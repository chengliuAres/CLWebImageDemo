//
//  CLImageManager.m
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "CLImageManager.h"
#import "CLDownloader.h"
@interface CLImageManager()
@property (nonatomic,strong) NSFileManager * fileManager;
@property (nonatomic,copy) NSString * photoCachePath;
@property (nonatomic,strong) NSCache * myCache;

@property (nonatomic,strong) NSMutableSet * failedUrlSet;
@property (nonatomic,strong) NSMutableDictionary * runOperationsDic;
@property (nonatomic,strong) CLDownloader * downloader;
@end

@implementation CLImageManager

static CLImageManager * imageManger = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!imageManger) {
            imageManger = [[CLImageManager alloc] init];
        }
    });
    return imageManger;
}
-(instancetype)init{
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
        NSString * PhotoCache = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/PhotoCaches"];
        _photoCachePath = PhotoCache;
        _myCache =[[NSCache alloc] init];
        _downloader = [CLDownloader shareInstance];
        _failedUrlSet = [NSMutableSet set];
        _runOperationsDic = [NSMutableDictionary new];
    }
    return self;
}
-(CLDownloadOperation *)loadImageWithUrl:(NSString *)urlStr Completed:(CLloadImageCompletedBlock)completedBlock{
    NSURL * url = nil;
    if ([urlStr isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:urlStr];
    }
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    __block CLDownloadOperation * operation = [[CLDownloadOperation alloc] init];
    BOOL isFailedUrl = NO;
    @synchronized(self.failedUrlSet){
        isFailedUrl = [self.failedUrlSet containsObject:url];
    }
    if (url.absoluteString.length == 0 || (isFailedUrl)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:1001 userInfo:nil];
            completedBlock(nil,nil,error,YES,url);
        });
        return nil;
    }
    NSString * key = [self cacheKeyForUrl:url];
    NSData * imageData = nil;
    imageData = [self dataFromCache:key];
    if (imageData) {
        if ((!operation.isCancelled)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * img = [UIImage imageWithData:imageData];
                completedBlock(img,imageData,nil,YES,url);
            });
            return operation;
        }else{
            [self.runOperationsDic removeObjectForKey:key];
            return nil;
        }
    }
    imageData = [self dataFromDisk:key];
    if (imageData) {
        if (!operation.isCancelled) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * img = [UIImage imageWithData:imageData];
                completedBlock(img,imageData,nil,YES,url);
            });
            [self storeImageToCache:imageData Key:key];
            return operation;
        }else{
            [self.runOperationsDic removeObjectForKey:key];
            return nil;
        }
    }
    if (!imageData) {
        __weak typeof(self) me = self;
        @synchronized(self.runOperationsDic){
            if (self.runOperationsDic[key]) {
                //防止不同控件下载同一源的图片
                NSData * data = [self reReadDataFromLocal:key];
                if (data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage * img = [UIImage imageWithData:data];
                        if (!operation.isCancelled) {
                            completedBlock(img,data,nil,YES,url);
                        }else{
                            [self.runOperationsDic removeObjectForKey:key];
                        }
                    });
                }else{
                    //收到其他线程相同图片下载完成的通知
                    [[NSNotificationCenter defaultCenter] addObserverForName:@"reReadImageAfterDownload" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                        NSString * urlStr2 = note.userInfo[@"url"];
                        if ([urlStr2 isEqualToString:urlStr]) {
                            NSData * data = note.userInfo[@"data"];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIImage * img = [UIImage imageWithData:data];
                                if (!operation.isCancelled) {
                                    completedBlock(img,data,nil,YES,url);
                                }else{
                                    [self.runOperationsDic removeObjectForKey:key];
                                }
                            });
                        }
                    }];
                    return operation;
                }
            }else{
                operation = [CLDownloader.shareInstance downloadImageWithUrl:url CompletedBlock:^(NSData *data, NSError *error, BOOL finished) {
                    if (!operation.isCancelled) {
                        if (!error && data) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIImage * img = [UIImage imageWithData:data];
                                completedBlock(img,imageData,nil,YES,url);
                            });
                        }else{
                            completedBlock(nil,nil,error,YES,url);
                        }
                        if (error) {
                            [me.failedUrlSet addObject:urlStr];
                        }
                    }
                    if (data) {
                        [me storeImageToCache:data Key:key];
                        [me storeImageToDisk:data Name:key];
                    }
                    [me.runOperationsDic removeObjectForKey:key];
                }];
                self.runOperationsDic[key] = operation;
            }
        }
    }
    return operation;
}
-(UIImage *)loadImageOnlyCache:(NSString *)url{
    UIImage * image;
    NSString * key = [self cacheKeyForUrlStr:url];
    NSData * data = [self dataFromCache:key];
    image = [UIImage imageWithData:data];
    return image;
}
-(UIImage *)loadImageOnlyDisk:(NSString *)url{
    UIImage * image;
    NSString * key = [self cacheKeyForUrlStr:url];
    NSData * data = [self dataFromDisk:key];
    image = [UIImage imageWithData:data];
    return image;
}
-(void)clearCache{
    [_failedUrlSet removeAllObjects];
    [self.myCache removeAllObjects];
}
-(void)clearDisk{
    if ([self.fileManager fileExistsAtPath:self.photoCachePath]) {
        [self.fileManager removeItemAtPath:self.photoCachePath error:nil];
    }
}
#pragma mark- private
-(NSData *)dataFromCache:(NSString *)key{
    NSData * data = [self.myCache objectForKey:key];
    return data;
}
-(NSData *)dataFromDisk:(NSString *)name{
    NSString * filePath = [self.photoCachePath stringByAppendingPathComponent:name];
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    return data;
}
-(NSData *)reReadDataFromLocal:(NSString *)key{
    NSData * data = [self dataFromCache:key];
    if (!data) {
        data = [self dataFromDisk:key];
    }
    return data;
}
-(void)storeImageToCache:(NSData *)imgData Key:(NSString *)name{
    [self.myCache setObject:imgData forKey:name];
}
-(void)storeImageToDisk:(NSData *)imgData Name:(NSString *)imageName{
    if (![self.fileManager fileExistsAtPath:self.photoCachePath]) {
        [self.fileManager createDirectoryAtPath:self.photoCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * filePath = [self.photoCachePath stringByAppendingPathComponent:imageName];
    if (![self.fileManager fileExistsAtPath:filePath]) {
        [self.fileManager createFileAtPath:filePath contents:imgData attributes:nil];
    }
}
-(NSString *)cacheKeyForUrl:(NSURL *)url{
    if (!url) {
        return @"";
    }
    return [url.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
}
-(NSString *)cacheKeyForUrlStr:(NSString *)str{
    if (!str) {
        return @"";
    }
    return [str stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
}
@end
