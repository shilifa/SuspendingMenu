//
//  SuspendedMenu.h
//  SuspendedMenu
//
//  Created by shilifa on 2019/8/8.
//  Copyright © 2019 shilifa. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SuspendedMenuStatus) {
    SuspendedMenuShowing = 0,
    SuspendedMenuUnused,
    SuspendedMenuTransluncence
};

@protocol SuspendedMenuDelegate <NSObject>

@required

-(void)suspendedMenuDidSelectedAtIndex:(NSInteger)selectedMenu;

@end

@interface SuspendedMenu : UIView

@property(nonatomic,weak) id<SuspendedMenuDelegate> menuDelegate;
@property(nonatomic,assign) SuspendedMenuStatus menuStatus;
@property(nonatomic,assign) BOOL menuAside;
@property(nonatomic,strong) UIImage *defaultMenuImage;
@property(nonatomic,assign) CGRect currentLocation;
@property(nonatomic,assign) CGFloat idledAlpha;

/**
 初始化view

 @param frame 初始位置
 @param menuData 菜单数据
 @return view对象
 */
-(instancetype)initViewWithFrame:(CGRect)frame MenuArray:(NSArray *)menuData;

/**
 展示矩形菜单
 */
-(void)showRectangleMenu;

/**
 隐藏矩形菜单
 */
-(void)hideRectangleMunu;
//-(void)showSquareMenu;
//-(void)hideSquareMenu;

@end


