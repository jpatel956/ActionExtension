//
//  ActionViewController.m
//  Action
//
//  Created by ind556 on 12/8/14.
//  Copyright (c) 2014 RetachSys. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Database.h"
static NSString *const kUTTypeAppExtensionFindLoginAction = @"org.appextension.find-login-action";
static NSString *const kUTTypeAppExtensionFindRegistrationAction = @"org.appextension.find-registration-action";


@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UITableView *tblRecords;

@property (nonatomic,strong)  NSMutableArray* arrayRecords;

@property (nonatomic,assign) BOOL isRegistration;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[Database shareDatabase] createEditableCopyOfDatabaseIfNeeded];
    
    _tblRecords.hidden = YES;
    
    _arrayRecords = [NSMutableArray arrayWithArray:[[Database shareDatabase] SelectAllFromTable:@"select * from password"]];
    
    if (_arrayRecords.count>0) {
        _tblRecords.hidden = NO;
        [_tblRecords reloadData];
        [_tblRecords setNeedsDisplay];
        [_tblRecords setNeedsLayout];
    }
    
    //To create Database
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL recordFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:kUTTypeAppExtensionFindRegistrationAction]) {
                
                _isRegistration = YES;
                // This is an image. We'll load it, then place it in our image view.
                [itemProvider loadItemForTypeIdentifier:kUTTypeAppExtensionFindRegistrationAction options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                    
                    NSLog(@"Des : %@",item);
                    NSDictionary* tempDict = (NSDictionary*)item;
                    
                   
                    NSString* insertData = [NSString stringWithFormat:@"Insert into password ('username','password') values('%@','%@')",tempDict[@"username"],tempDict[@"password"]];
                    
                    [[Database shareDatabase] Insert:insertData];
                    
                    _arrayRecords = [NSMutableArray arrayWithArray:[[Database shareDatabase] SelectAllFromTable:@"select * from password"]];
                    
                    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
                    
                }];
                recordFound = YES;
                break;
            }
        }
        
        if (recordFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}
-(void)reloadTable{
    _tblRecords.hidden = NO;
    
    [_tblRecords reloadData];
    [_tblRecords setNeedsDisplay];
    [_tblRecords setNeedsLayout];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
    
}


#pragma mark +++++++++++++++++ Table View Methods ++++++++++++++++++++
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayRecords.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UILabel* lblTitle = (UILabel*)[cell.contentView viewWithTag:10];
    lblTitle.text = _arrayRecords[indexPath.row][@"username"];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_isRegistration) {
        
        NSDictionary* userDetails = _arrayRecords[indexPath.row];
        
        NSDictionary* dictUserInformation = [NSDictionary dictionaryWithObjectsAndKeys:userDetails[@"username"],@"username",userDetails[@"password"],@"password", nil];
        
        NSExtensionItem* extensionItem = [[NSExtensionItem alloc] init];
        [extensionItem setAttributedTitle:[[NSAttributedString alloc] initWithString:@"User Information"]];
        [extensionItem setAttachments:@[[[NSItemProvider alloc] initWithItem:dictUserInformation typeIdentifier:kUTTypeAppExtensionFindLoginAction]]];
        
        [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];

    }
}
@end
