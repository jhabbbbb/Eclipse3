//
//  ViewController.m
//  Eclipse3
//
//  Created by jhx on 15/11/12.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import "mainViewController.h"
#import "editViewController.h"
#import "createViewController.h"
#import "customCellTableViewCell.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface mainViewController () {
    int k;
    UISearchBar *searchBar;
}

@end

@implementation mainViewController
@synthesize notes;
@synthesize titles;
@synthesize createTimes;
@synthesize image;
@synthesize table;

//数据库
- (void)findDocuments {
    
    NSArray *document_path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [document_path objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[path stringByAppendingPathComponent:@"eclipse3.db"]];
    //NSLog(databasePath);
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
    
    //清除全部数组中的数据
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
            
            if ([sta isEqualToString:@"Normal"]){
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

- (void)selectObject:(NSString *)objects {
    
    //清除全部数组中的数据
    [titles removeAllObjects];
    [notes removeAllObjects];
    [createTimes removeAllObjects];
    
    //搜索内容是否包含关键字
    sqlite3_stmt * statement;
    NSString *sql = [[NSString alloc]initWithFormat:@"SELECT * FROM ECLIPSE3 WHERE CONTENT LIKE '%%%@%%'", objects];;
    
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *ch4= (char*)sqlite3_column_text(statement, 4);
            NSString *sta = [[NSString alloc]initWithUTF8String:ch4];
            
            if ([sta isEqualToString:@"Normal"]){
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
    
    //搜索题目是否包含关键字
    sql = [[NSString alloc]initWithFormat:@"SELECT * FROM ECLIPSE3 WHERE TITLE LIKE '%%%@%%'", objects];;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *ch4= (char*)sqlite3_column_text(statement, 4);
            NSString *sta = [[NSString alloc]initWithUTF8String:ch4];
            
            if ([sta isEqualToString:@"Normal"]){
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

}//读取被搜索的数据

- (void)deleteObjects:(NSString *)objects {
    
    //没有考虑内容一样
    NSString *deleteSql = [[NSString alloc]initWithFormat:@"DELETE FROM ECLIPSE3 WHERE CONTENT = '%@'", objects];
    
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        if ([self execSQL:deleteSql] != SQLITE_OK) {
            NSLog(@"delete failed.");
        }
        sqlite3_close(database);
    }
    
}//删除数据

- (void)archiveObjects:(NSString *)objects {
    
    //没有考虑内容一样
    NSString *sql = [[NSString alloc]initWithFormat:@"UPDATE ECLIPSE3 SET STATUS = 'Archived' WHERE TITLE = '%@'", objects];
    
    int result = [self execSQL:sql];
    if (result != SQLITE_OK){
        NSLog(@"update failed");
    }
    
}//归档数据

//tableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"custom";
    customCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[customCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLabel.text = titles[indexPath.row];
    cell.contentLabel.text = notes[indexPath.row];
    
    //tableView背景透明
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new];
    cell.selectedBackgroundView = [UIView new];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //customCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    editViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"editVC"];
    vc.titleText = titles[indexPath.row];
    vc.contentText = notes[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}//进入编辑页面

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}//编辑设置

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}//编辑设置

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //删除按钮
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        customCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [notes removeObjectAtIndex:indexPath.row];
        [titles removeObjectAtIndex:indexPath.row];
        [createTimes removeObjectAtIndex:indexPath.row];
        [self deleteObjects:(NSString *)cell.contentLabel.text];
        
        [self.table reloadData];
        
    }];
    
    delete.backgroundColor = [UIColor redColor];
    
    //归档按钮
    UITableViewRowAction *archive = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"归档" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        customCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self archiveObjects:(NSString *)cell.titleLabel.text];
        [notes removeObjectAtIndex:indexPath.row];
        [titles removeObjectAtIndex:indexPath.row];
        [createTimes removeObjectAtIndex:indexPath.row];
        
        [self.table reloadData];
    }];
    
    archive.backgroundColor = [UIColor orangeColor];
    
    //查看更多信息按钮
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        customCellTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.contentLabel.text isEqualToString:notes[indexPath.row]]){
            cell.contentLabel.text = [[NSString alloc]initWithFormat:@"创建时间： %@", createTimes[indexPath.row]];
        }
        else {
            cell.contentLabel.text = notes[indexPath.row];
        }
        [UIView beginAnimations:@"turnCell" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
        [UIView commitAnimations];
        [tableView setEditing:NO animated:YES];
    
    }];
    
    more.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    
    return @[delete, archive, more];
    
}//在滑动时，显示出更多的按钮

//AFNetworking改变背景图片
- (void)changeBackground {
    
    NSMutableArray *url = [[NSMutableArray alloc]initWithObjects:@"http://d.3987.com/jxpgbz_140409/007.jpg", @"http://cdn.duitang.com/uploads/item/201307/26/20130726150900_2FCrY.thumb.600_0.jpeg", @"http://img5.duitang.com/uploads/item/201412/14/20141214143116_SedAU.jpeg", @"http://img5.duitang.com/uploads/item/201412/06/20141206012104_v2x5j.thumb.700_0.jpeg", @"http://cdnq.duitang.com/uploads/item/201412/06/20141206012043_P4MtB.jpeg",nil];
    
    int i = arc4random()%5;//随机选取
    
    [image setImageWithURL:[NSURL URLWithString:url[i]]];
    
}

//搜索
- (IBAction)searchButton: (id)sender {
    
    //搜索框出现&消失，k＝0表示应该出现，k＝1表示应该消失
    if (k == 0){
        k = 1;
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 375, 40)];
        searchBar.delegate = self;
        [searchBar setPlaceholder:@"搜索"];
        [self.view addSubview:searchBar];
        [searchBar becomeFirstResponder];
        //tableView下移
        table.transform = CGAffineTransformTranslate(table.transform, 0, 40);
    }
    else if (k == 1){
        k = 0;
        [searchBar removeFromSuperview];
        //tableView上移
        table.transform = CGAffineTransformTranslate(table.transform, 0, -40);
        [self selectAllObjects];
        [self.table reloadData];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self selectObject:searchText];
    [self.table reloadData];
}//随着搜索框文字变化即时搜索

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
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self changeBackground];
    k = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//没用
- (IBAction)addButton:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"create"]){
        //createViewController *vc = segue.destinationViewController;
        
    }
}

@end
