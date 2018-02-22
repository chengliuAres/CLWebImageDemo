//
//  UIView+CLCacheOperation.m
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/15.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "UIView+CLCacheOperation.h"
#import <objc/runtime.h>

static char OperationsKey;

@implementation UIView (CLCacheOperation)

-(NSMutableDictionary *)operationDictionary{
    NSMutableDictionary * operations = objc_getAssociatedObject(self, &OperationsKey);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &OperationsKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

///设置UIView 所对应的操作
-(void)cl_setImageLoadOperation:(id)operation forKey:(NSString *)key{
    [self cl_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary * dic = [self operationDictionary];
    [dic setObject:operation forKey:key];
}

///暂停当前UIView key对应的所有操作
-(void)cl_cancelImageLoadOperationWithKey:(NSString *)key{
    NSMutableDictionary * operationsDic = [self operationDictionary];
    id operation = operationsDic[key];
    if (operation && [operation isKindOfClass:[CLDownloadOperation class]]) {
        [operation cancelDownload];
    }
    [operationsDic removeObjectForKey:key];
}

///删除UIView key对应的所有操作
-(void)cl_removeImageLoadOperationWithKey:(NSString *)key{
    NSMutableDictionary * operationDic = [self operationDictionary];
    [operationDic removeObjectForKey:key];
}

@end
