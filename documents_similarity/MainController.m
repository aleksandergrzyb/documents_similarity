//
//  MainController.m
//  documents_similarity
//
//  Created by Aleksander Grzyb on 05/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import "MainController.h"
#import "DocumentsParser.h"
#import "KeywordsParser.h"

@interface MainController () <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *documentFileTitle;
@property (weak) IBOutlet NSTextField *keywordFileTitle;
@property (weak) IBOutlet NSTextField *queryTextField;
@property (nonatomic, strong) NSOpenPanel *panel;
@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, strong) NSArray *documents;
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
        self.documentFileTitle.stringValue = [filePath lastPathComponent];
        DocumentsParser *documentsParser = [[DocumentsParser alloc] init];
        self.documents = [documentsParser parseDocumentFromFilePath:filePath];
        [self.tableView reloadData];
    }
}

- (IBAction)openKeywordsPressed:(id)sender
{
    NSString *filePath = [self openFile];
    if (filePath) {
        self.keywordFileTitle.stringValue = [filePath lastPathComponent];
        KeywordsParser *keywordsParser = [[KeywordsParser alloc] init];
        self.keywords = [keywordsParser parseKeywordsFromFilePath:filePath];
    }
}
- (IBAction)executeQueryPressed:(NSButton *)sender
{
    
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

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.documents.count;
}

#pragma mark -
#pragma mark Table View Delegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if ([tableColumn.identifier isEqualToString:@"document"]) {
        cellView.textField.stringValue = self.documents[row][DOCUMENTS_TITLE_KEY];
        return cellView;
    }
    else if ([tableColumn.identifier isEqualToString:@"score"]) {
        cellView.textField.stringValue = [self.documents[row][DOCUMENTS_SCORE_KEY] stringValue];
        return cellView;
    }
    return cellView;
}

@end
