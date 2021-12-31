//
//  ViewController.m
//  CardDemo
//
//  Created by 陈经伟 on 2021/11/9.
//

#import "ViewController.h"
#import "CJWCardView.h"
#import "Masonry/Masonry.h"
@interface ViewController ()<CJWCardViewDelegate>
@property (nonatomic, weak) CJWCardView *card;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //支持frame布局和masonry布局
    //使用方法，创建后布局，设置dataSource，执行reload方法
    
    CJWCardView *card = [CJWCardView new];
    card.frame = CGRectMake(self.view.frame.size.width / 2 - 150, self.view.frame.size.height / 2-100, 300, 200);
    card.delegate = self;
    for (int i = 0; i < 5; i ++) {
        [self.view addSubview:card];
    }
    card.dataSource = @[@"1",@"2",@"3",@"4",@"5",@"6"];

    [card reloadData];
    
    self.card = card;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(200, 100, 100, 30);
    [button setTitle:@"切换数据源" forState:0];
    [button addTarget:self action:@selector(changeData:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}

- (void)changeData:(UIButton *)sender{
//    self.card.dataSource = @[@"1",@"2",@"3"];
//    [self.card reloadData];
    
    NSUInteger index = arc4random_uniform(5);
    [sender setTitle:[NSString stringWithFormat:@"滚动到第%zd页",index] forState:0];
    self.card.selectIndex = index;
}

#pragma mark - CJWCardViewDelegate
- (void)cardViewWillMove:(CJWCardView *)cardView fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)index{
    
}

- (void)cardViewDidMove:(CJWCardView *)cardView fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)index{
    
}


@end
