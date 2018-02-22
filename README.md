# CLWebImageDemo
提供一个类似SDWebImage图片异步加载框架的简单设计思路

### 主要使用方法

#### 1 设置图片

```objective-c
[cell.imageView cl_setImageWithURL:_dataArr[indexPath.row] placeHolder:[UIImage imageNamed:@"default.jpg"] completion:^(UIImage *image) {
        
    }];
```

### 2 清除缓存

```objective-c
[CLImageManager.shareInstance clearCache];
[CLImageManager.shareInstance clearDisk];
```

### 编写思路：

[简书链接]<https://www.jianshu.com/p/7edb18d3442c>



