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
#import "TFIDFSimilarity.h"
#import "Constans.h"

@interface MainController () <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *executeQueryButton;
@property (weak) IBOutlet NSTextField *documentFileTitle;
@property (weak) IBOutlet NSTextField *keywordFileTitle;
@property (weak) IBOutlet NSTextField *queryTextField;
@property (nonatomic, strong) NSOpenPanel *panel;
@property (nonatomic, strong) NSArray *keywords;
@property (nonatomic, strong) NSArray *documents;
@property (nonatomic) BOOL documentsLoaded;
@property (nonatomic) BOOL keywordsLoaded;
@end

@implementation MainController

- (id)init
{
    self = [super init];
    if (self) {
        self.documentsLoaded = NO;
        self.keywordsLoaded = NO;
    }
    return self;
}

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
        self.documentsLoaded = YES;
        if (self.keywordsLoaded) {
            [self.executeQueryButton setEnabled:YES];
        }
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
        self.keywordsLoaded = YES;
        if (self.documentsLoaded) {
            [self.executeQueryButton setEnabled:YES];
        }
    }
}
- (IBAction)executeQueryPressed:(NSButton *)sender
{
    self.documents = [TFIDFSimilarity calculateScoresForDocuments:self.documents keywords:self.keywords andQuery:self.queryTextField.stringValue];
    [self.tableView reloadData];
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

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    self.documents = [self.documents sortedArrayUsingDescriptors:[tableView sortDescriptors]];
    [tableView reloadData];
}

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
