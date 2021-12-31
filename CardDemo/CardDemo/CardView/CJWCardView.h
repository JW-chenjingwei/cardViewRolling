//
//  CardView.h
//  CardDemo
//
//  Created by 陈经伟 on 2021/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CJWCardView;

@protocol CJWCardViewDelegate <NSObject>


@optional
- (void)cardViewWillMove:(CJWCardView *)cardView fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)index;

- (void)cardViewDidMove:(CJWCardView *)cardView fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)index;

@end


//使用方法，创建后布局，设置dataSource，执行reload方法
@interface CJWCardView : UIView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id <CJWCardViewDelegate>delegate;
///默认滑动到第几页
@property (nonatomic, assign) NSUInteger selectIndex;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
