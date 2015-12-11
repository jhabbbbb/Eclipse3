//
//  editViewController.m
//  Eclipse3
//
//  Created by jhx on 15/11/16.
//  Copyright © 2015年 jhx. All rights reserved.
//

#import "editViewController.h"

@interface editViewController ()

@end

@implementation editViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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

- (void)updateObject {
    NSString *sql = [[NSString alloc]initWithFormat:@"UPDATE ECLIPSE3 SET TITLE = '%@', CONTENT = '%@' WHERE TITLE = '%@'", self.titleView.text,self.contentView.text, self.titleText];
    
    int result = [self execSQL:sql];
    if (result != SQLITE_OK){
        NSLog(@"update failed");
    }
}

//dismissKeyboard
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
}

//ViewController初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //连接数据库
    [self findDocuments];
    [self createDatabase];
    
    //初始化界面
    self.titleView.text = self.titleText;
    self.contentView.text = self.contentText;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.titleView becomeFirstResponder];
    
    //dismissKeyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

//确认按钮
- (IBAction)save:(id)sender {
    [self updateObject];
}




@end
