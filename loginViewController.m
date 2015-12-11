//
//  loginViewController.m
//  Eclipse3
//
//  Created by jhx on 15/11/12.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import "loginViewController.h"

@interface loginViewController ()

@end

@implementation loginViewController
@synthesize userName;
@synthesize psw;

//viewController初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    userName.delegate = self;
    psw.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//文本框
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -40.0;
        self.view.frame = frame;
    }];
    return YES;
}//弹出键盘界面上浮

- (BOOL)textFieldShouldReturn:(UITextField *) thetextField {
    
    if (thetextField == userName){
        [thetextField resignFirstResponder];
        [psw becomeFirstResponder];
    }
    else if (thetextField == psw){
        [psw resignFirstResponder];
    }
    return YES;
}//转移编辑状态

- (BOOL)textFieldShouldEndEditing:(UITextField *)thetextField {
    
    if (thetextField == psw){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = 0.0;
            self.view.frame = frame;
        }];
    }
    return YES;
}//键盘消失界面下降

@end
