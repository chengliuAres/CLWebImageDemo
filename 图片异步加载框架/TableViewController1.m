//
//  TableViewController1.m
//  图片异步加载框架
//
//  Created by AppleCheng on 2018/2/13.
//  Copyright © 2018年 AppleCheng. All rights reserved.
//

#import "TableViewController1.h"
#import "CLImageManager.h"
#import "UIImageView+CLWebCache.h"
@interface TableViewController1 ()
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation TableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 150;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _dataArr = [@[@"http://pic34.photophoto.cn/20150113/0006019095934688_b.jpg",
                  @"http://pic34.photophoto.cn/20150113/0006019095934688_b.jpg",
                  @"http://pic34.photophoto.cn/20150113/0006019095934688_b.jpg",
                  @"http://img.taopic.com/uploads/allimg/110202/292-11020203332568.jpg",
                  @"http://pic1.16pic.com/00/07/85/16pic_785034_b.jpg",
                  @"http://pic.58pic.com/58pic/12/46/03/95f58PICjsh.jpg",
                  @"http://pic6.nipic.com/20100401/4214896_084729026258_2.jpg",
                  @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2902871148,1976814992&fm=27&gp=0.jpg",
                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1518586999107&di=480ae1a938e35da9e2d0dea116437f07&imgtype=0&src=http%3A%2F%2Fwww.cn357.com%2Fud%2Fbatchimg%2Forg%2F261%2Fp31499490.jpg",
                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1518577315&di=c4f6fd3d105ea4b0ebdb823d3547e275&src=http://n.sinaimg.cn/sinacn/w640h382/20171218/0dcc-fypsqka8286071.jpg",
                  @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=595176747,2914764557&fm=27&gp=0.jpg",
                  @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=595176747,2914764557&fm=27&gp=0.jpg",
                  @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=595176747,2914764557&fm=27&gp=0.jpg",
                  @"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1518577315&di=0a1ed5882e64c914804b46451e2dd712&src=http://www.ahxyddc.com/product/images/20140310105938.jpg"]mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个",indexPath.row+1];
    cell.imageView.image = [UIImage imageNamed:@"default.jpg"];

    cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    [cell.imageView cl_setImageWithURL:_dataArr[indexPath.row] placeHolder:[UIImage imageNamed:@"default.jpg"] completion:^(id sender) {
        
    }];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
