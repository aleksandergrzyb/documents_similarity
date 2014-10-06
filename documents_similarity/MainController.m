//
//  MainController.m
//  documents_similarity
//
//  Created by Aleksander Grzyb on 05/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import "MainController.h"
#import "DocumentsParser.h"

@interface MainController ()
@property (nonatomic, strong) NSOpenPanel *panel;
@end

@implementation MainController

- (NSOpenPanel *)panel
{
    if (!_panel) {
        _panel = [NSOpenPanel openPanel];
        _panel.allowedFileTypes = [NSArray arrayWithObjects:@"txt", nil];
        _panel.allowsMultipleSelection = NO;
    }
    return _panel;
}

- (IBAction)openDocumentsPressed:(id)sender
{
    NSString *filePath = [self openFile];
    if (filePath) {
        DocumentsParser *documentsParser = [[DocumentsParser alloc] init];
        [documentsParser parseDocumentFromFilePath:filePath];
    }
}

- (IBAction)openTermsPressed:(id)sender
{
    NSString *filePath = [self openFile];
    if (filePath) {
        NSLog(@"Filename: %@", filePath);
    }
}

- (NSString *)openFile
{
    NSString *filePath = nil;
    if ([self.panel runModal] == NSOKButton) {
        NSArray *selectedFiles = self.panel.URLs;
        filePath = [[selectedFiles objectAtIndex:0] path];
    }
    return filePath;
}

@end
