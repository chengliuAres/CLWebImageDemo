//
//  UIView+CLCacheOperation.h
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/15.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDownloadOperation.h"
///该UIView关联有NSOperation
@interface UIView (CLCacheOperation)
///设置UIView 所对应的操作
-(void)cl_setImageLoadOperation:(CLDownloadOperation *)operation forKey:(NSString *)key;

///暂停当前UIView key对应的所有操作
-(void)cl_cancelImageLoadOperationWithKey:(NSString *)key;

///删除UIView key对应的所有操作
-(void)cl_removeImageLoadOperationWithKey:(NSString *)key;

@end
