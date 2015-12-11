//
//  createViewController.h
//  Eclipse3
//
//  Created by jhx on 15/11/12.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface createViewController : UIViewController{
    sqlite3 *database;
    NSString *databasePath;
}

@property (strong, nonatomic) IBOutlet UITextView *titleView;
@property (strong, nonatomic) IBOutlet UITextView *contentView;

@end