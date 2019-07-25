//
//  ViewController.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/6/24.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "RuntimeSelectorTest.h"
#import "RuntimeClassTest.h"
#import "RuntimeProtocolTest.h"
#import "TestImageViewController.h"
#import "NSURL+Extension.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nullable) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [self setupView];
    [self setupFrame];
    [self setupData];
}

- (void)setupView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

- (void)setupFrame {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupData {
    
}

#pragma mark - UITableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *text = [[NSString alloc] initWithFormat:@"%ld - %ld", indexPath.section, indexPath.row];
    if (indexPath.row == 0) {
        text = @"方法交换";
    } else if (indexPath.row == 1) {
        text = @"遍历 镜像 和 类";
    } else if (indexPath.row == 2) {
        text = @"打印协议中的方法";
    } else if (indexPath.row == 3) {
        text = @"分类测试 - UIImage";
    }
    cell.textLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"func%ld", indexPath.row]);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
}

- (void)func0 {
    [RuntimeSelectorTest test];
}

- (void)func1 {
    [RuntimeClassTest test];
}

- (void)func2 {
    [RuntimeProtocolTest test];
}

- (void)func3 {
    TestImageViewController *vc = [[TestImageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)func4 {
    NSString *str = @"https://www.google.com.hk/search?safe=strict&biw=1920&bih=897&ei=ORE4XenaEe6umAXhqp3ICA&q=ios+url+encode&oq=ios++url+&gs_l=psy-ab.3.1.0l10.86626.91769..93612...3.0..0.241.2298.0j10j3......0....1..gws-wiz.....0..0i10j0i12j0i30j0i8i30j0i5i30.ujS1cPbBxIA&name=%e5%b0%8f%e7%ba%a2123";
    NSURL *url = [NSURL URLWithString:str];
    NSDictionary *dic1 = [url ext_queryParameters];
    NSDictionary *dic2 = [url ext_queryParametersDecoded];
    NSLog(@"dic1:%@", dic1);
    NSLog(@"dic2:%@", dic2);
}

@end

