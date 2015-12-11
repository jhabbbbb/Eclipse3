//
//  editViewController.h
//  Eclipse3
//
//  Created by jhx on 15/11/16.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface editViewController : UIViewController{
    sqlite3 *database;
    NSString *databasePath;
}
@property (strong, nonatomic) IBOutlet UITextView *titleView;
@property (strong, nonatomic) IBOutlet UITextView *contentView;
@property (copy, nonatomic) NSString *titleText;
@property (copy, nonatomic) NSString *contentText;


@end
