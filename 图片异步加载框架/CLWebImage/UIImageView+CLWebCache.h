//
//  UIImageView+CLWebCache.h
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/22.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CLLoadImageCallBack)(UIImage * image);

@interface UIImageView (CLWebCache)
-(void)cl_setImageWithURL:(NSString *)urlStr placeHolder:(UIImage *)imageHolder completion:(CLLoadImageCallBack)completion;

@end
