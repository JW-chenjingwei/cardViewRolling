//
//  CJWCardItemView.m
//  CardDemo
//
//  Created by 陈经伟 on 2021/11/9.
//

#import "CJWCardItemView.h"
#import "CJWCardViewMacro.h"
@interface CJWCardItemView ()

//距离中心距离
@property (nonatomic,assign)CGFloat xFromCenter;
@property (nonatomic,assign)CGFloat yFromCenter;

@end
@implementation CJWCardItemView{
    UILabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
        
        //消除锯齿
        self.layer.allowsEdgeAntialiasing = YES;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        panGesture.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)setupViews{
    self.layer.cornerRadius = 10;
    
    self.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    UILabel *titleL = [UILabel new];
    [self addSubview:titleL];
    titleL.frame = self.frame;
    _titleLabel = titleL;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

#pragma mark - 拖拽事件处理

-(void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    self.xFromCenter = [gesture translationInView:self].x;
    self.yFromCenter = [gesture translationInView:self].y;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(cardItemWillBeginMove:xFromCenter:)]) {
                [self.delegate cardItemWillBeginMove:self xFromCenter:self.xFromCenter];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.center = CGPointMake(self.originalCenter.x + self.xFromCenter, self.originalCenter.y);
            NSLog(@"%f---%f",self.originalCenter.x,self.xFromCenter);
            if(self.delegate){
                [self.delegate moveCardsX:self.xFromCenter Y:self.yFromCenter];
            }
           
            if (fabs(self.xFromCenter)>MIN(kCJW_Action_Margin_Right, kCJW_Action_Margin_Left)) {
                gesture.state = UIGestureRecognizerStateEnded;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self followUpActionWithDistance:self.xFromCenter andVelocity:[gesture velocityInView:self.superview]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 拖拽后续事件处理

-(void)followUpActionWithDistance:(CGFloat)distance andVelocity:(CGPoint)velocity {
    if (distance > 0 && (distance > kCJW_Action_Margin_Right || velocity.x > kCJW_Action_Velocity)) {
        [self rightAction:velocity];
    } else if (distance < 0 && (distance < -kCJW_Action_Margin_Right || velocity.x < -kCJW_Action_Velocity)) {
        [self leftAction:velocity];
    }else {
        //复位
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.center = self.originalCenter;
            self.transform = self.originalTransform;
        } completion:nil];
        
        if (self.delegate){
            [self.delegate moveBackCards];
        }
            
    }
}

#pragma mark - 左边移出

-(void)leftAction:(CGPoint)velocity {
    if (self.delegate)
        [self.delegate cardItemRemoved:self Direction:CJWCardItemRemoveDirectionLeft];
}

#pragma mark - 右边移出
-(void)rightAction:(CGPoint)velocity {
    if (self.delegate)
        [self.delegate cardItemRemoved:self Direction:CJWCardItemRemoveDirectionRight];
}
@end
