//
//  YYHighPerViewController.m
//  YYTableViewDemo
//
//  Created by yuyou on 2018/1/18.
//  Copyright © 2018年 yy. All rights reserved.
//

#import "YYHighPerViewController.h"
#import "YYHighPerCarModel.h"
#import "YYHighPerDataManager.h"
#import "YYHighPerTableViewCell.h"
#import "YYLoadingView.h"
#import "MJRefresh.h"

@interface YYHighPerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;//主tableview
@property (nonatomic,strong) NSMutableArray *dataArray;//数据

@end

@implementation YYHighPerViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUIComponent];
    [self setRefreshFooter];
    [self getDataAndShow];
}

#pragma mark - UI
- (void)setUIComponent
{
    self.extendedLayoutIncludesOpaqueBars = YES;//从顶部开始布局
    self.automaticallyAdjustsScrollViewInsets = NO;//自动算内边距
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *seperatorLineOfNav = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT + STATUS_HEIGHT, kMainScreenWidth, 1)];
    [self.view addSubview:seperatorLineOfNav];
    seperatorLineOfNav.backgroundColor = UIColorFromRGB(0xebebeb);
}

- (void)setRefreshFooter
{
    //设置表格上拉下拉功能
    __weak typeof(self) weakSelf = self;
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [YYHighPerDataManager getCarListDataWithBlock:^(NSArray *dataArray, NSError *error) {
            if (dataArray == nil || dataArray.count == 0)
            {
                [weakSelf.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                //移到异步线程做
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //构造需要刷新的索引
                    NSMutableArray *indexArray = [NSMutableArray array];
                    NSInteger beginIndex = weakSelf.dataArray.count;
                    for (int i = 0; i < dataArray.count; i++)
                    {
                        [indexArray addObject:[NSIndexPath indexPathForRow:beginIndex + i inSection:0]];
                    }
                    [weakSelf.dataArray addObjectsFromArray:dataArray];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.mainTableView.mj_footer endRefreshing];
                        [weakSelf.mainTableView beginUpdates];
                        [weakSelf.mainTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.mainTableView endUpdates];
                    });
                });
            }
        }];
    }];
    ((MJRefreshAutoNormalFooter *)self.mainTableView.mj_footer).triggerAutomaticallyRefreshPercent = -20;
    ((MJRefreshAutoNormalFooter *)self.mainTableView.mj_footer).stateLabel.font = [UIFont systemFontOfSize:11];
    //上拉的文字
    [((MJRefreshAutoNormalFooter *)self.mainTableView.mj_footer) setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [((MJRefreshAutoNormalFooter *)self.mainTableView.mj_footer) setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [((MJRefreshAutoNormalFooter *)self.mainTableView.mj_footer) setTitle:@"没有更多了哦" forState:MJRefreshStateNoMoreData];
}

#pragma mark - 事件响应
- (void)getDataAndShow
{
    __weak typeof(self) weakSelf = self;
    [YYLoadingView showInView:self.view beginY:(NAVBAR_HEIGHT + STATUS_HEIGHT + 1) withBackColor:self.view.backgroundColor];
    [YYHighPerDataManager getCarListDataWithBlock:^(NSArray *dataArray, NSError *error) {
        [YYLoadingView removeFromView:weakSelf.view];
        weakSelf.dataArray = [dataArray mutableCopy];
        [weakSelf.mainTableView reloadData];
    }];
}

#pragma mark - tableview代理、数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYHighPerTableViewCell *cell = [YYHighPerTableViewCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YYHighPerTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YYHighPerTableViewCell getCellHeight];
}

#pragma mark - 懒加载
- (UITableView *)mainTableView
{
    if (!_mainTableView)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (NAVBAR_HEIGHT + STATUS_HEIGHT + 1), kMainScreenWidth, kMainScreenHeight - (NAVBAR_HEIGHT + STATUS_HEIGHT + 1)) style:UITableViewStylePlain];
        [self.view addSubview:_mainTableView];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *))//表示只在ios11以上的版本执行
        {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainTableView;
}

@end

