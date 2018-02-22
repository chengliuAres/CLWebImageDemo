//
//  UIImageView+CLWebCache.m
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "UIImageView+CLWebCache.h"
#import "UIView+CLCacheOperation.h"
#import <objc/runtime.h>
#import "CLImageManager.h"
static char CLImageUrlKey;
@implementation UIImageView (CLWebCache)

-(void)cl_setImageWithURL:(NSString *)urlStr placeHolder:(UIImage *)imageHolder completion:(CLLoadImageCallBack)completion{
    
    [self cl_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &CLImageUrlKey, urlStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (imageHolder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = imageHolder;
        });
    }
    if (urlStr) {
        __weak typeof(self) me = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CLDownloadOperation * operation = [CLImageManager.shareInstance loadImageWithUrl:urlStr Completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished, NSURL *imageUrl) {
                if (!me) {
                    return ;
                }
                if (image) {
                    self.image = image;
                    [me setNeedsDisplay];
                    completion?completion(image):nil;
                }else if(error){
                    completion?completion(nil):nil;
                    NSLog(@"CLWebImage-ERROR: %@",error.localizedDescription);
                }
            }];
            [self cl_setImageLoadOperation:operation forKey:@"UIImageViewLoad_Operation"];
        });
    }else{
        NSLog(@"CLWebImage-ERROR: url error!");
    }
}
///取消当前图片的设置任务
-(void)cl_cancelCurrentImageLoad{
    [self cl_cancelImageLoadOperationWithKey:@"UIImageViewLoad_Operation"];
}
@end
