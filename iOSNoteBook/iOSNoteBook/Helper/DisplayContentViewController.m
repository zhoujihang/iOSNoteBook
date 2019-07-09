//
//  DisplayContentViewController.m
//  iOSNoteBook
//
//  Created by 周际航 on 2019/7/9.
//  Copyright © 2019年 zjh. All rights reserved.
//

#import "DisplayContentViewController.h"

@interface DisplayContentViewController ()

@property (nonatomic, strong, nullable) UITextView *textView;

@end

@implementation DisplayContentViewController

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
    self.navigationItem.title = self.title;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareContent)];
    self.navigationItem.rightBarButtonItems = @[shareItem];
    
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:self.textView];
}

- (void)setupFrame {
    self.textView.frame = self.view.frame;
}

- (void)setupData {
    self.textView.text = self.content;
    self.textView.contentOffset = CGPointMake(0, -self.textView.contentInset.top);
}

- (void)shareContent {
    NSString *sharedText = self.content;
    UIActivityViewController *c = [[UIActivityViewController alloc] initWithActivityItems:@[sharedText] applicationActivities:nil];
    [self presentViewController:c animated:YES completion:nil];
}

@end
