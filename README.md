# SuspendingMenu
a control that show and hide suspending menu

## 使用

```Objective-C
 NSArray *menuArray = @[
                           @[@"共享",@"publicShare"],
                           @[@"足迹",@"footprint"],
                           @[@"轨迹",@"trail"],
                           ];<br>
    SuspendedMenu *menuView = [[SuspendedMenu alloc] initViewWithFrame:CGRectMake(20, 20, 55, 55) MenuArray:menuArray];<br>
    menuView.menuDelegate = self;<br>  
    menuView.defaultMenuImage = [UIImage imageNamed:@"caidan"];<br>
    [self.view addSubview:menuView];<br>
    [self.view bringSubviewToFront:menuView]; 
    ```
