# SuspendingMenu
a control that show and hide suspending menu

## 使用

 NSArray *menuArray = @[
                           @[@"共享",@"publicShare"],
                           @[@"足迹",@"footprint"],
                           @[@"轨迹",@"trail"],
                           ];
    SuspendedMenu *menuView = [[SuspendedMenu alloc] initViewWithFrame:CGRectMake(20, 20, 55, 55) MenuArray:menuArray];
    menuView.menuDelegate = self;
    menuView.defaultMenuImage = [UIImage imageNamed:@"caidan"];
    [self.view addSubview:menuView];
    [self.view bringSubviewToFront:menuView];
    
