//
//  ViewController.h
//  Eclipse3
//
//  Created by jhx on 15/11/12.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface mainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
    NSString *databasePath;
    sqlite3 *database;
}


@property (copy, nonatomic) NSMutableArray *titles;
@property (copy, nonatomic) NSMutableArray *notes;
@property (copy, nonatomic) NSMutableArray *createTimes;
@property (copy, nonatomic) NSMutableArray *ids;//没用

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITableView *table;

@end

