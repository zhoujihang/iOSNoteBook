//
//  TestImageViewController.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/23.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "TestImageViewController.h"
#import "UIImage+Extension.h"

@interface TestImageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nullable) UIImageView *imgView;
@property (nonatomic, strong, nullable) UIImageView *maskImgView;

@end

@implementation TestImageViewController

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
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    
    self.maskImgView = [[UIImageView alloc] init];
    self.maskImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.maskImgView.clipsToBounds = YES;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.maskImgView];
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
        [self func_setup];
        [self performSelector:sel];
        [self func_teardown];
    }
}

- (void)func_setup {
    self.imgView.frame = CGRectMake(200, 400, 100, 100);
    self.maskImgView.frame = CGRectMake(200, 400, 100, 100);
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    self.imgView.image = nil;
    self.maskImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.maskImgView.clipsToBounds = YES;
    self.maskImgView.image = nil;
}
- (void)func_teardown {
    
}

- (void)func0 {
    self.imgView.image = [UIImage ext_resizeImageWithName:@"死神狂潮"];
}
- (void)func1 {
    self.imgView.image = [[UIImage imageNamed:@"死神狂潮"] ext_resizeImage];
}
- (void)func2 {
    self.imgView.image = [UIImage ext_imageWithColor:[UIColor cyanColor]];
}
- (void)func3 {
    self.imgView.image = [UIImage imageNamed:@"奥特曼"];
    self.maskImgView.image = [UIImage ext_circleTransparentImageWithDiameter:20];
}
- (void)func4 {
    self.imgView.image = [UIImage imageNamed:@"奥特曼"];
    self.maskImgView.image = [UIImage ext_imageWithSize:CGSizeMake(100, 100) cornerRadius:30 rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight fillColor:[UIColor clearColor] radiusColor:[UIColor greenColor]];
}
- (void)func5 {
    self.imgView.image = [[UIImage imageNamed:@"亲吻"] ext_circleImage];
}
- (void)func6 {
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.image = [[UIImage imageNamed:@"旅行"] ext_ovalImage];
}
- (void)func7 {
    self.imgView.image = [UIImage ext_gradientImageWithSize:CGSizeMake(100, 100) startColor:[UIColor redColor] endColor:[UIColor blueColor] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(100, 100)];
}
- (void)func8 {
    self.imgView.frame = CGRectMake(200, 200, 200, 400);
    self.imgView.image = [UIImage ext_imageWithView:self.navigationController.view];
}

@end
