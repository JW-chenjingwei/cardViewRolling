//
//  CardView.m
//  CardDemo
//
//  Created by 陈经伟 on 2021/11/9.
//

#import "CJWCardView.h"
#import "CJWCardItemView.h"

#import "CJWCardViewMacro.h"


@interface CJWCardView()<CJWCardItemDelegate>

@property (strong, nonatomic) NSMutableArray <CJWCardItemView *>*disPlayArray;//展示的数组


@property (nonatomic, assign) NSUInteger index;

@property (assign, nonatomic) CGPoint originalCenter;
@property (assign, nonatomic) CGAffineTransform originalTransform;

@end
@implementation CJWCardView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initProperty];
        
    }
    return self;
}

- (void)setSelectIndex:(NSUInteger)selectIndex{
    
    if (selectIndex > self.disPlayArray.count - 1 || selectIndex < 0) {
        return;
    }
    _selectIndex = selectIndex;
    
    
    if (selectIndex < self.index) {//右滑
        [self moveCardsX:20 Y:0];
        for (NSUInteger i = self.index ; i > selectIndex;i--) {
            
            CJWCardItemView *cardItem = [self searchItemViewWithIndex:i];
            [self cardItemRemoved:cardItem Direction:CJWCardItemRemoveDirectionRight];
        }
        
    }else if (selectIndex > self.index){//左滑
        [self moveCardsX:-20 Y:0];
        for (NSUInteger i = self.index ; i < selectIndex;i++) {
            CJWCardItemView *cardItem = [self searchItemViewWithIndex:i];
            [self cardItemRemoved:cardItem Direction:CJWCardItemRemoveDirectionLeft];
        }
        
    }else{
        //不变
    }
    
    
}

- (void)reloadData{
    [self layoutIfNeeded];
    
    for (UIView *subView in self.subviews) {
        if ([subView isMemberOfClass:CJWCardItemView.class]) {
            [subView removeFromSuperview];
        }
    }
    
    [self.disPlayArray removeAllObjects];
    
    [self setupViews];
    [self setLayouts];
    
}
- (void)initProperty {
    self.backgroundColor = [UIColor clearColor];
    self.disPlayArray = [NSMutableArray new];
    self.index = 0;
}

- (void)setupViews{
    if (!self.dataSource) {
        return;
    }
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        NSString *img = self.dataSource[i];
        CJWCardItemView *itemView = [[CJWCardItemView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        itemView.title = img;
        itemView.index = i;
        itemView.delegate = self;
        [self.disPlayArray addObject:itemView];
        if (i == 0) {
            itemView.userInteractionEnabled = YES;
        } else {
            itemView.userInteractionEnabled = NO;
        }
        
    }
    
    //add
    for (NSInteger i = self.dataSource.count - 1; i >= 0; i--) {
        [self addSubview:self.disPlayArray[i]];
    }
    
    
    

    
}

- (void)setLayouts{
    //layout
    for (NSInteger i = 0; i < self.disPlayArray.count; i++) {
        CJWCardItemView *card = self.disPlayArray[i];
        CGPoint finishPoint = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
        card.center = finishPoint;
        card.transform = CGAffineTransformMakeRotation(0);
        card.alpha = 1;
        if (i == 0) {
            self.originalCenter = finishPoint;
            self.originalTransform = card.transform;

        } else {
            CJWCardItemView *preCard = self.disPlayArray.firstObject;
            card.transform = CGAffineTransformMakeScale(kCJW_CardScale, kCJW_CardScale);

            
            CGPoint center = preCard.center;
            center.x += 40;
            card.center = center;
        }
        
        card.originalCenter = card.center;
        card.originalTransform = card.transform;
    }
}


#pragma mark - CJWCardItemDelegate
//滑动中更改其他卡片位置

- (void)moveCardsX:(CGFloat)xDistance Y:(CGFloat)yDistance{
    
    //右边:当前页的上一页移到第二层
    if (xDistance > 10) {
        if (self.index == 0) {
            return;
        }
        CJWCardItemView *currenCard = [self searchItemViewWithIndex:self.index];
        CJWCardItemView *preCard = [self searchItemViewWithIndex:self.index - 1];
        [self insertSubview:preCard belowSubview:currenCard];
    }
    //左边：当前页的下一页移到第二层
    else if (xDistance < -10){
        if (self.index == self.disPlayArray.count-1) {
            return;
        }
        
        CJWCardItemView *currenCard = [self searchItemViewWithIndex:self.index];
        CJWCardItemView *preCard = [self searchItemViewWithIndex:self.index + 1];
        [self insertSubview:preCard belowSubview:currenCard];
    }
}



- (void)cardItemWillBeginMove:(CJWCardItemView *)card xFromCenter:(CGFloat)xFromCenter{
        
    NSUInteger toIndex = 0;
    //右边
    if (xFromCenter > 0) {

        toIndex = self.index - 1;
        
    }
    //左边
    else if (xFromCenter < 0){
        toIndex = self.index + 1;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(cardViewWillMove:fromIndex:toIndex:)]) {
        [self.delegate cardViewWillMove:self fromIndex:self.index toIndex:toIndex];
    }
}


- (void)cardItemRemoved:(CJWCardItemView *)card Direction:(CJWCardItemRemoveDirection)direction {
    
   
    //左滑，下一页
    if (direction == CJWCardItemRemoveDirectionLeft) {
        
        //最后一页左滑，复位
        if (self.index == self.dataSource.count - 1) {
            [self moveBackCards];
            return;
        }
        
        NSUInteger nextIndex = [self.disPlayArray indexOfObject:card] + 1;
        CJWCardItemView *nextCard = [self searchItemViewWithIndex:nextIndex];
        if (!nextCard) {
            return;
        }
        
        [UIView animateWithDuration:kCJW_Move_Animation_Time delay:0.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
            nextCard.center = self.originalCenter;
            nextCard.transform = self.originalTransform;
            nextCard.originalCenter = self.originalCenter;
            nextCard.originalTransform = self.originalTransform;
            CGPoint center = nextCard.center;
            center.x -= kCJW_CenterX;
            card.center = center;
            card.transform = CGAffineTransformMakeScale(kCJW_CardScale, kCJW_CardScale);
        } completion:^(BOOL finished) {
            [self bringSubviewToFront:nextCard];
            [self insertSubview:card belowSubview:nextCard];
        }];
        
        card.userInteractionEnabled = NO;
        nextCard.userInteractionEnabled = YES;
        
        
        
        if ([self.delegate respondsToSelector:@selector(cardViewDidMove:fromIndex:toIndex:)]) {
            [self.delegate cardViewDidMove:self fromIndex:self.index toIndex:nextIndex];
        }
        
        
        self.index = nextIndex;
    }
    //右滑，上一页
    else{
        
        //第一页右滑，复位
        if (self.index == 0) {
            [self moveBackCards];
            return;
        }
        
        NSUInteger preIndex = [self.disPlayArray indexOfObject:card] - 1;
        CJWCardItemView *preCard = [self searchItemViewWithIndex:preIndex];
        if (!preCard) {
            return;
        }
       
        
        [UIView animateWithDuration:kCJW_Move_Animation_Time delay:0.0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
            preCard.center = self.originalCenter;
            preCard.transform = self.originalTransform;
            preCard.originalCenter = self.originalCenter;
            preCard.originalTransform = self.originalTransform;
            CGPoint center = preCard.center;
            center.x += kCJW_CenterX;
            card.center = center;
            card.transform = CGAffineTransformMakeScale(kCJW_CardScale, kCJW_CardScale);
        } completion:^(BOOL finished) {
            [self bringSubviewToFront:preCard];
            [self insertSubview:card belowSubview:preCard];
        }];
        card.userInteractionEnabled = NO;
        preCard.userInteractionEnabled = YES;
        
        
        if ([self.delegate respondsToSelector:@selector(cardViewDidMove:fromIndex:toIndex:)]) {
            [self.delegate cardViewDidMove:self fromIndex:self.index toIndex:preIndex];
        }
        
        self.index = preIndex;
    }
    
}



- (void)moveBackCards{
    //复位除第一张卡片的位置
    CJWCardItemView *card = [self searchItemViewWithIndex:self.index];
    card.userInteractionEnabled = NO;
    [UIView animateWithDuration:kCJW_Move_Animation_Time delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        card.center = self.originalCenter;
        card.transform = self.originalTransform;
    } completion:^(BOOL finished) {
        card.userInteractionEnabled = YES;
    }];
}

- (CJWCardItemView *)searchItemViewWithIndex:(NSUInteger)index{

    if (index > self.disPlayArray.count - 1) {
        return nil;
    }
    return self.disPlayArray[index];
    
}
@end
