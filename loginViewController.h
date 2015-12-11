//
//  loginViewController.h
//  Eclipse3
//
//  Created by jhx on 15/11/12.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *psw;

@end
