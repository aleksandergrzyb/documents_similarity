//
//  DocumentsParser.m
//  documents_similarity
//
//  Created by Aleksander Grzyb on 05/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import "DocumentsParser.h"

@implementation DocumentsParser

- (NSArray *)parseDocumentFromFilePath:(NSString *)filePath
{
    NSArray *documents = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            content = [content lowercaseString];
            content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""];
            NSLog(@"%@", content);
        }
        else {
            NSLog(@"ERROR: Cannot load content of file.");
        }
    }
    else {
        NSLog(@"ERROR: File doesn't exist in selected path.");
    }
    return documents;
}

@end
