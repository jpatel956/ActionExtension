//
//  ActionViewController.m
//  Action
//
//  Created by ind556 on 12/8/14.
//  Copyright (c) 2014 RetachSys. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
static NSString *const kUTTypeAppExtensionFindLoginAction = @"org.appextension.find-login-action";


@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:kUTTypeAppExtensionFindLoginAction]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:kUTTypeAppExtensionFindLoginAction options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                    
                    NSLog(@"Des : %@",item);
                    NSDictionary* tempDict = (NSDictionary*)item;
                    [imageView setImage:[tempDict valueForKey:@"image"]];
                    
                }];
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
//    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
    
    NSDictionary* dictUserInformation = [NSDictionary dictionaryWithObjectsAndKeys:@"Jatin",@"username",@"jatin123",@"password", nil];
    
    NSExtensionItem* extensionItem = [[NSExtensionItem alloc] init];
    [extensionItem setAttributedTitle:[[NSAttributedString alloc] initWithString:@"User Information"]];
    [extensionItem setAttachments:@[[[NSItemProvider alloc] initWithItem:dictUserInformation typeIdentifier:kUTTypeAppExtensionFindLoginAction]]];
    
    [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];
}

@end
