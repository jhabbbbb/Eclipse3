//
//  archivesViewController.h
//  Eclipse3
//
//  Created by jhx on 15/11/18.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface archivesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSString *databasePath;
    sqlite3 *database;
}

@property (weak, nonatomic) IBOutlet UILabel *label;//标题“归档（0）”

@property (copy, nonatomic) NSMutableArray *titles;
@property (copy, nonatomic) NSMutableArray *notes;
@property (copy, nonatomic) NSMutableArray *createTimes;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end
