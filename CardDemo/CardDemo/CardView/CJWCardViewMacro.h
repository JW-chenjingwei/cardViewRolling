//
//  CardView.h
//  CardView
//
//  Created by chenjw on 2017/12/20.
//  Copyright © 2021年 libcore. All rights reserved.
//

#ifndef CJWCardViewMacro_h
#define CJWCardViewMacro_h


#define kCJW_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define kCJW_ScreenHeight [UIScreen mainScreen].bounds.size.height

//展示数量
//#define kCJW_CardCacheNumber 3
//缩放比例
#define kCJW_CardScale 0.9

#define kCJW_CenterX 40

//移出极限值，大于直接移出
#define kCJW_Action_Margin_Left 160
#define kCJW_Action_Margin_Right 160

//移出速度极限值，大于直接移出
#define kCJW_Action_Velocity 200

//动画时间
#define kCJW_Move_Animation_Time 0.25




#endif /* CJWCard_h */
