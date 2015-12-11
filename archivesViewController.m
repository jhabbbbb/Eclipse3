//
//  archivesViewController.m
//  Eclipse3
//
//  Created by jhx on 15/11/18.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import "archivesViewController.h"
#import "archiveCell.h"
#import "AFNetworking.h"
#import"UIKit+AFNetworking.h"

@interface archivesViewController ()

@end

@implementation archivesViewController
@synthesize titles;
@synthesize notes;
@synthesize createTimes;
@synthesize image;
//数据库
- (void)findDocuments {
    NSArray *document_path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [document_path objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[path stringByAppendingPathComponent:@"eclipse3.db"]];
}

- (int)execSQL:(NSString *)sql {
    
    char *errmsg;
    int result = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    return result;
    
}//数据库执行语句

- (void)createDatabase {
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS ECLIPSE3 (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, CONTENT TEXT, CREATETIME TEXT, STATUS TEXT)";
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        int result = [self execSQL:sql];
        if (result != SQLITE_OK){
            NSLog(@"create failed");
        }
    }
}//建立数据库

- (void)selectAllObjects {
    
    //清除全部数据
    [titles removeAllObjects];
    [notes removeAllObjects];
    [createTimes removeAllObjects];
    
    //重新读取数据
    NSString *sql = @"SELECT * FROM ECLIPSE3";
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *ch4= (char*)sqlite3_column_text(statement, 4);
            NSString *sta = [[NSString alloc]initWithUTF8String:ch4];
            
            if ([sta isEqualToString:@"Archived"]){
                //title
                char *ch1= (char*)sqlite3_column_text(statement, 1);
                NSString *title = [[NSString alloc]initWithUTF8String:ch1];
                [titles addObject:title];
                //content
                char *ch2= (char*)sqlite3_column_text(statement, 2);
                NSString *note = [[NSString alloc]initWithUTF8String:ch2];
                [notes addObject:note];
                //createtime
                char *ch3= (char*)sqlite3_column_text(statement, 3);
                NSString *creTime = [[NSString alloc]initWithUTF8String:ch3];
                [createTimes addObject:creTime];
            }
            
        }
    }
    
}//读取全部数据

- (void)deleteObjects:(NSString *)objects {
    
    //没考虑内容一样
    NSString *deleteSql = [[NSString alloc]initWithFormat:@"DELETE FROM ECLIPSE3 WHERE TITLE = '%@'", objects];
    
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        if ([self execSQL:deleteSql] != SQLITE_OK) {
            NSLog(@"delete failed.");
        }
        sqlite3_close(database);
    }
}//删除数据

//tableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"archive";
    archiveCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[archiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLabel.text = titles[indexPath.row];
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}//编辑设置（不知道有什么用）

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}//编辑设置（不知道有什么用）

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
    archiveCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [notes removeObjectAtIndex:indexPath.row];
    [titles removeObjectAtIndex:indexPath.row];
    [createTimes removeObjectAtIndex:indexPath.row];
    
    [self deleteObjects:(NSString *)cell.titleLabel.text];
    
    [self.table reloadData];
    
}//删除

//AFNetworking改变背景图片
- (void)changeBackground {
    
    NSMutableArray *url = [[NSMutableArray alloc]initWithObjects:@"http://d.3987.com/jxpgbz_140409/007.jpg", @"http://img5.duitang.com/uploads/item/201501/05/20150105184318_w8HPK.jpeg", @"http://img5.duitang.com/uploads/item/201412/14/20141214143116_SedAU.jpeg", @"http://img5.duitang.com/uploads/item/201412/06/20141206012104_v2x5j.thumb.700_0.jpeg",nil];
    
    int i = arc4random()%4;//随机选择
    
    [image setImageWithURL:[NSURL URLWithString:url[i]]];
}

//ViewController初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数组
    notes = [[NSMutableArray alloc]initWithCapacity:42];
    titles = [[NSMutableArray alloc]initWithCapacity:42];
    createTimes = [[NSMutableArray alloc]initWithCapacity:42];
    
    //数据库
    [self findDocuments];
    [self createDatabase];
    [self selectAllObjects];
    
    //初始化界面
    [self.label setText:[[NSString alloc]initWithFormat: @"归档 (%lu)",(unsigned long)[notes count]]];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self changeBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
