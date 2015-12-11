//
//  editViewController.m
//  Eclipse3
//
//  Created by jhx on 15/11/12.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import "createViewController.h"

@interface createViewController ()

@end

@implementation createViewController

//数据库
- (NSString *)findDocuments {
    NSArray *document_path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [document_path objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[path stringByAppendingPathComponent:@"eclipse3.db"]];
    return path;
}

- (int)execSQL:(NSString *)sql {
    char *errmsg;
    int result = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errmsg);
    return result;
}

- (void)createDatabase {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS ECLIPSE3 (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, CONTENT TEXT, CREATETIME TEXT, STATUS)";
    if (sqlite3_open([databasePath UTF8String], &database)==SQLITE_OK) {
        int result = [self execSQL:sql];
        if (result != SQLITE_OK){
            NSLog(@"create failed");
        }
    }
}

- (void)insertObject {
    //获取系统时间
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    //插入
    NSString *sql = [[NSString alloc]initWithFormat: @"INSERT INTO ECLIPSE3 (TITLE, CONTENT, CREATETIME, STATUS) VALUES('%@', '%@', '%@', '%@')",self.titleView.text, self.contentView.text, date, @"Normal"];
    //NSLog(sql);
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        int result = [self execSQL:sql];
        if(result != SQLITE_OK) {
            NSLog(@"insert failed, %d",result);
        }
        
    }
    sqlite3_close(database);
}

//DismissKeyboard
- (void)dismissKeyboard {
    [self.titleView resignFirstResponder];
    [self.contentView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextView *) thetextView {
    
    if (thetextView == self.titleView){
        [thetextView resignFirstResponder];
        [self.contentView becomeFirstResponder];
    }
    return YES;
}//转换编辑状态

//UIViewController初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据库
    [self findDocuments];
    [self createDatabase];
    
    //初始化界面
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.titleView becomeFirstResponder];
    
    //dismissKeyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//确认按钮
- (IBAction)save:(id)sender {
    [self insertObject];
}



@end
