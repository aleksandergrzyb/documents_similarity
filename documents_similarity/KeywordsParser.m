//
//  KeywordsParser.m
//  documents_similarity
//
//  Created by Aleksander Grzyb on 10/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import "KeywordsParser.h"
#import "NSString+PorterStemmer.h"

@implementation KeywordsParser

- (NSArray *)parseKeywordsFromFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            content = [content lowercaseString];
            NSArray *keywordsArray = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSMutableArray *stemmedKeywordsArray = [NSMutableArray array];
            for (NSString *keyword in keywordsArray) {
                NSString *stemmedTerm = [keyword stem];
                [stemmedKeywordsArray addObject:stemmedTerm];
            }
            return [stemmedKeywordsArray copy];
        }
        else {
            NSLog(@"ERROR: Cannot load content of file.");
        }
    }
    else {
        NSLog(@"ERROR: File doesn't exist in selected path.");
    }
    return [NSArray array];
}

@end
