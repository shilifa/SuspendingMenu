//
//  SuspendedMenu.m
//  SuspendedMenu
//
//  Created by shilifa on 2019/8/8.
//  Copyright © 2019 shilifa. All rights reserved.
//

#import "SuspendedMenu.h"
#import "UIButton+CVButton.h"
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
static const CGFloat kAsideAnimationTime = 0.3;
static const CGFloat kDefaultPaddingValue = 5;
static const CGFloat kSelectPaddingValue = 80;

@interface SuspendedMenu()
@property (nonatomic,strong) UIImageView *defaultMenuImageView;
@property (nonatomic,strong) NSArray *menuData;
@property (nonatomic,strong) NSMutableArray *menuBtnArr;

@end

@implementation SuspendedMenu

-(instancetype)initViewWithFrame:(CGRect)frame MenuArray:(NSArray *)menuData{
    self = [super initWithFrame:frame];
    self.menuData = menuData;
    [self setupMenuView];
    return self;
}

-(void)setupMenuView{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 55/2.0f;
    self.backgroundColor = UIColor.lightGrayColor;
    self.menuStatus = SuspendedMenuTransluncence;
    self.currentLocation = self.frame;
    [self addSubview:self.defaultMenuImageView];
    //拖拽手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movingMenuView:)];
    [self addGestureRecognizer:panGesture];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenuView:)];
    [self addGestureRecognizer:tapGesture];
}

//-(void)showSquareMenu{
//    [UIView animateWithDuration:0.5 animations:^{
//        self.backgroundColor = UIColor.darkGrayColor;
//        self.frame = CGRectMake(kSelectPaddingValue, ScreenHeight/2 - (ScreenWidth/2 - kSelectPaddingValue), ScreenWidth - kSelectPaddingValue *2, ScreenWidth - kSelectPaddingValue *2);
//        self.menuStatus = SuspendedMenuShowing;
//    }];
//}
//
//-(void)hideSquareMenu{
//    [UIView animateWithDuration:0.5 animations:^{
//        self.backgroundColor = UIColor.lightGrayColor;
//        self.menuStatus = SuspendedMenuUnused;
//        self.frame =  self.currentLocation;
//    }];
//}

-(void)showRectangleMenu{
    self.menuStatus = SuspendedMenuShowing;
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if (self.currentLocation.origin.x <= ScreenWidth/2) {
        [self.menuBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *item = (UIButton *)obj;
            item.frame = CGRectMake(55*(idx+1)+5, 5, 45, 45);
            item.hidden = NO;
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(self.currentLocation.origin.x, self.currentLocation.origin.y, self.currentLocation.size.width + 165, self.currentLocation.size.height);
            self.defaultMenuImageView.frame = CGRectMake(5, 5, 45, 45);
        }];
    }else{
        [self.menuBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *item = (UIButton *)obj;
           item.frame = CGRectMake(55*(idx) + 5, 5, 45, 45);
            item.hidden = NO;
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(self.currentLocation.origin.x - 165, self.currentLocation.origin.y, self.currentLocation.size.width + 165, self.currentLocation.size.height);
            self.defaultMenuImageView.frame = CGRectMake(55 *3 + 5, 5, 45, 45);
        }];
    }
}

-(void)hideRectangleMunu{
    self.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = self.currentLocation;
    } completion:^(BOOL finished) {
        self.defaultMenuImageView.frame = CGRectMake(5, 5, 45, 45);
        self.menuStatus = SuspendedMenuUnused;
        [self.menuBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *itemBtn = (UIButton *)obj;
            itemBtn.hidden = YES;
        }];
    }];
}

-(void)setDefaultMenuImage:(UIImage *)defaultMenuImage{
    self.defaultMenuImageView.image = defaultMenuImage;
}

#pragma mark - 手势 -
-(void)movingMenuView:(UIPanGestureRecognizer *)panGesture{
    if (self.menuStatus == SuspendedMenuUnused || self.menuStatus == SuspendedMenuTransluncence) {
        CGPoint point = [panGesture locationInView:[panGesture.view superview]];
        if (panGesture.state == UIGestureRecognizerStateEnded) {
            CGPoint finalPoint = CGPointMake(point.x, point.y);
            if (point.x <= ScreenWidth/2) {
                finalPoint.x = self.frame.size.width/2 + kDefaultPaddingValue;
            }else{
                finalPoint.x = ScreenWidth - kDefaultPaddingValue - self.frame.size.width/2;
            }
            if (point.y < kDefaultPaddingValue + self.frame.size.height/2) {
                finalPoint.y = kDefaultPaddingValue + self.frame.size.height/2;
            }else if (point.y > ScreenHeight - (self.frame.size.height/2 + kDefaultPaddingValue)){
                finalPoint.y = ScreenHeight - (self.frame.size.height/2 + kDefaultPaddingValue);
            }
            [self changeFrameWithAnimationTime:kAsideAnimationTime andPoint:finalPoint];
        }else if (panGesture.state == UIGestureRecognizerStateChanged){
            self.center = point;
        }
    }else{
        [self hideRectangleMunu];
    }
}

-(void)tapMenuView:(UITapGestureRecognizer*)tapGesture{
    if (self.menuStatus == SuspendedMenuTransluncence || self.menuStatus == SuspendedMenuUnused) {
        [self showRectangleMenu];
    }else{
        [self hideRectangleMunu];
    }
}

#pragma mark - lazy load -
-(UIImageView *)defaultMenuImageView{
    if (_defaultMenuImageView == nil) {
        _defaultMenuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
        _defaultMenuImageView.clipsToBounds = YES;
        _defaultMenuImageView.layer.cornerRadius = 45/2;
        _defaultMenuImageView.userInteractionEnabled = YES;
    }
    return _defaultMenuImageView;
}

#pragma mark - other method -
-(void)changeFrameWithAnimationTime:(CGFloat)time andPoint:(CGPoint)finalFrame{
    self.currentLocation = CGRectMake(finalFrame.x - self.frame.size.width/2, finalFrame.y - self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:time animations:^{
        self.center = finalFrame;
    }];
}

-(NSMutableArray *)menuBtnArr{
    if (_menuBtnArr == nil) {
        _menuBtnArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i <self.menuData.count; i++) {
            NSArray *btnDataArr = self.menuData[i];
            UIButton *itemBtn =  [self createItemBtnWithData:btnDataArr];
            [_menuBtnArr addObject:itemBtn];
            [self addSubview:itemBtn];
        }
    }
    return _menuBtnArr;
}

-(UIButton *)createItemBtnWithData:(NSArray *)btnData{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [btn setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    [btn setTitle:btnData[0] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:btnData[1]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:6.0f];
    return btn;
}

-(void)itemBtnSelected:(UIButton *)button{
    NSInteger selectIndex;
    if ([button.titleLabel.text isEqualToString:@"共享"]) {
        selectIndex = 0;
    }else if([button.titleLabel.text isEqualToString:@"足迹"]){
        selectIndex = 1;
    }else{
        selectIndex = 2;
    }
    if ([_menuDelegate respondsToSelector:@selector(suspendedMenuDidSelectedAtIndex:)]) {
        [_menuDelegate suspendedMenuDidSelectedAtIndex:selectIndex];
    }
}



@end
