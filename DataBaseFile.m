//
//  DataBaseFile.m
//  DatabaseDemo
//
//  Created by Hardik Patel on 8/24/15.
//  Copyright (c) 2015 Hardik Patel. All rights reserved.
//

#import "DataBaseFile.h"
static DataBaseFile *singleton = nil;
@implementation DataBaseFile

+(DataBaseFile *)databaseFile
{
    if (singleton == nil)
    {
        singleton = [[DataBaseFile alloc] init];
    }
    return singleton;
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
-(void)CopyDatabaseInDevice
{
  //  KidsDB.sqlite
    
  //  KidsDB.sqlite
    
    NSString *sourcepath = [[NSBundle mainBundle] pathForResource:@"KidsDB" ofType:@"sqlite"]; // get source path
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); // get base path from device
    
    NSString *strDestPath = [arr objectAtIndex:0];
    
     NSError *error;
    NSString *dataPath = [strDestPath stringByAppendingPathComponent:@"/MyFolder"];
    
    self.ImageFolderPath = [NSString stringWithFormat:@"%@",dataPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    


    strDestPath = [strDestPath stringByAppendingPathComponent:@"KidsDB.sqlite"]; // slash add karava mate
    self.databasePath = strDestPath;
    
    NSLog(@"%@",self.databasePath);
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:self.databasePath]==NO) {
        [filemanager copyItemAtPath:sourcepath toPath:self.databasePath error:nil];
    }
    
   

    
    // Get documents folder
    
    
    
    
}



-(void)insertDataWithQuesy:(NSString *)insertQuery
{
//    char *error;
//    
//    if (sqlite3_open([self.databasePath UTF8String], &sqlite)==SQLITE_OK)
//    {
//        if (sqlite3_exec(sqlite,[insertQuery UTF8String],NULL, NULL, &error)==SQLITE_OK)
//        {
//            //  //NSLog(@"insert record sucessfully");
//        }
//        else
//        {
//            
//        }
//    }
//    else
//    {
//    }
//    
//    sqlite3_close(sqlite);
//
    
    char *error;
    
    if (sqlite3_open([self.databasePath UTF8String],&_sqlite )==SQLITE_OK) {
        
        if (sqlite3_exec(self.sqlite, [insertQuery UTF8String], 0, 0, &error)==SQLITE_OK) {
            NSLog(@"insert successfully");
        }
        else
        {
            NSLog(@"not insert");

        }
    }
    else
    {
        NSLog(@"database not available");
    }
    
    
    
    
}



-(NSMutableArray *)selectAllDataWithSingleFieldTablewithQuery:(NSString *)selectQuery
{
    self.selectAllData=[[NSMutableArray alloc] init];
    
    if (sqlite3_open([self.databasePath UTF8String], &_sqlite)==SQLITE_OK) {
        
        sqlite3_stmt *stmt;
        
        
        if (sqlite3_prepare_v2(self.sqlite, [selectQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK) {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
            [self.selectAllData addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)] ];
            }
        }
        sqlite3_finalize(stmt);
        
    }
    
    return self.selectAllData;
    
    

    
   
    
}

-(NSString *)MathOperationInTable:(NSString *)selectQuery
{
    NSString *mathstr;
    
    if (sqlite3_open([self.databasePath UTF8String], &_sqlite)==SQLITE_OK) {
        
        sqlite3_stmt *stmt;
        
        
        if (sqlite3_prepare_v2(self.sqlite, [selectQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK) {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
               mathstr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)] ;
            }
        }
        sqlite3_finalize(stmt);
        
    }

    return mathstr;
    
}





-(NSMutableArray *)selectAllDataFromTablewithQuery:(NSString *)selectQuery ofColumn:(int)numOfColumn
{
   
    self.selectAllData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([self.databasePath UTF8String], &_sqlite)==SQLITE_OK) {
        
        sqlite3_stmt *stmt;
        
        
        if (sqlite3_prepare_v2(self.sqlite, [selectQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK) {
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                NSMutableArray *localArr = [[NSMutableArray alloc] init];
                
                for (int i=0; i<numOfColumn; i++) {
                    [localArr addObject:((char *)sqlite3_column_text(stmt, i))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)] : @""];
                }
              
                [self.selectAllData addObject:localArr];
                
                

            }
        }
        sqlite3_finalize(stmt);

    }
    
    return self.selectAllData;
    
}


-(void)UpdateDataWithQuesy:(NSString *)UpdateQuery
{
    char *error;
    
    if (sqlite3_open([self.databasePath UTF8String],&_sqlite )==SQLITE_OK) {
        
        if (sqlite3_exec(self.sqlite, [UpdateQuery UTF8String], 0, 0, &error)==SQLITE_OK) {
            //NSLog(@"Update successfully");
        }
        else
        {
            //NSLog(@"not Update");
            
        }
    }
    else
    {
        //NSLog(@"database not available");
    }
    

}


-(void)DeleteDataWithQuesy:(NSString *)DeleteQuery
{
    char *error;
    
    if (sqlite3_open([self.databasePath UTF8String],&_sqlite )==SQLITE_OK) {
        
        if (sqlite3_exec(self.sqlite, [DeleteQuery UTF8String], 0, 0, &error)==SQLITE_OK) {
            //NSLog(@"Delete successfully");
        }
        else
        {
            //NSLog(@"not Delete");
            
        }
    }
    else
    {
        //NSLog(@"database not available");
    }
    

}


-(NSMutableArray *)selectTableDatawithQuery:(NSString *)selectQuery
{
    
    self.selectAllData = [[NSMutableArray alloc] init];
    
    if (sqlite3_open([self.databasePath UTF8String], &_sqlite)==SQLITE_OK) {
        
        sqlite3_stmt *stmt;
        
        
        
        if (sqlite3_prepare_v2(self.sqlite, [selectQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK) {
            
            int numOfColumn = sqlite3_column_count(stmt);
            
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                for (int i=0; i<numOfColumn; i++) {
                    
                    const char *_columnName=sqlite3_column_name(stmt, i);
                    
                    NSString *columnName=[[NSString alloc] initWithUTF8String:_columnName];
                    
                    [dict setObject:((char *)sqlite3_column_text(stmt, i))?[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)] : @"" forKey:columnName];
                }
                
                [self.selectAllData addObject:dict];
                
                
            }
        }
        sqlite3_finalize(stmt);
        
    }
    
    return self.selectAllData;
    
}


@end
