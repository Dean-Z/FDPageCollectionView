//
//  ViewController.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "ViewController.h"
#import "FDPageCollectionView.h"
#import "FDPageTableViewCell.h"

#define BARandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mockData];
    [self.view addSubview:self.tableView];
}

- (void)mockData {
    self.dataArray = @[].mutableCopy;
    for (int i=0; i<10; i++) {
        NSInteger count = arc4random() % 6 + 3;
        NSMutableArray *imgData = @[].mutableCopy;
        for (int i=0; i<count; i++) {
            [imgData addObject:[NSString stringWithFormat:@"img_%u",arc4random()%18 + 1]];
        }
        [self.dataArray addObject:imgData];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playCurrentCellVideo];
    });
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FDPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell render:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self playCurrentCellVideo];
}

- (void)playCurrentCellVideo {
    NSArray *currentShowingCell = self.tableView.visibleCells;
    if (currentShowingCell.count > 0) {
        FDPageTableViewCell *cell = [currentShowingCell firstObject];
        [cell prepareCollectionVideo];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FDPageTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
