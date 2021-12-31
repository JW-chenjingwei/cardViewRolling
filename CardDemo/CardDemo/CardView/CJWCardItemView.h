//
//  CardItemView.h
//  CardDemo
//
//  Created by 陈经伟 on 2021/11/9.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CJWCardItemRemoveDirection) {
    CJWCardItemRemoveDirectionLeft,
    CJWCardItemRemoveDirectionRight
};

@class CJWCardItemView;

@protocol CJWCardItemDelegate <NSObject>

- (void)cardItemWillBeginMove:(CJWCardItemView *)card xFromCenter:(CGFloat)xFromCenter;


- (void)cardItemRemoved:(CJWCardItemView *)card Direction:(CJWCardItemRemoveDirection)direction;

- (void)moveCardsX:(CGFloat)xDistance Y:(CGFloat)yDistance;

- (void)moveBackCards;



@end



@interface CJWCardItemView : UIView
@property (nonatomic, copy) NSString *title;

@property (assign, nonatomic) CGPoint originalCenter;
@property (assign, nonatomic) CGAffineTransform originalTransform;

@property (nonatomic, weak) id <CJWCardItemDelegate>delegate;

//标识
@property (nonatomic, assign) NSUInteger index;
@end

