//
//  Database.h
//  ActionExtension
//
//  Created by Jatin Patel on 4/15/15.
//  Copyright (c) 2015 RetachSys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface Database : NSObject {
    
    sqlite3 *databaseObj;
    
}
+(Database*) shareDatabase;

-(BOOL) createEditableCopyOfDatabaseIfNeeded;
-(NSString *) GetDatabasePath:(NSString *)dbName;

-(NSMutableArray *)SelectAllFromTable:(NSString *)query;
-(int)getCount:(NSString *)query;
-(BOOL)CheckForRecord:(NSString *)query;
-(void)Insert:(NSString *)query;
-(void)Delete:(NSString *)query;
-(void)Update:(NSString *)query;
-(int)GetSum:(NSString*)query;
@end

