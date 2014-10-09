//
//  DocumentsParser.m
//  documents_similarity
//
//  Created by Aleksander Grzyb on 05/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import "DocumentsParser.h"
#import "NSString+PorterStemmer.h"
#import "porter2_stemmer.h"

@implementation DocumentsParser

- (NSArray *)parseDocumentFromFilePath:(NSString *)filePath
{
    NSMutableArray *documentsArray = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            content = [content lowercaseString];
            content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@""];
            NSArray *documents = [content componentsSeparatedByString:@"\n\n"];
            for (NSString *document in documents) {
                NSArray *documentLines = [document componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                NSString *documentTitle = [documentLines firstObject];
                NSString *documentBody = [document substringFromIndex:documentTitle.length];
                documentTitle = [self convertStringToStemString:documentTitle];
                NSLog(@"1: %@", documentBody);
                documentBody = [[documentBody componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                documentBody = [documentBody stringByReplacingOccurrencesOfString:@"|" withString:@""];
                NSLog(@"2: %@", documentBody);
                documentBody = [self convertStringToStemString:documentBody];
                NSDictionary *documentDictionary = @{
                                                    documentTitle : DOCUMENTS_TITLE_KEY,
                                                    documentBody : DOCUMENTS_BODY_KEY
                                                    };
                [documentsArray addObject:documentDictionary];
                
                
                NSLog(@"%@", [documentDictionary description]);
            }
        }
        else {
            NSLog(@"ERROR: Cannot load content of file.");
        }
    }
    else {
        NSLog(@"ERROR: File doesn't exist in selected path.");
    }
    return [documentsArray copy];
}

- (NSString *)convertStringToStemString:(NSString *)string
{
    NSString *stemString = @"";
    if (string && string.length > 0) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
        if (!error) {
            NSString *trimmedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@" "];
            
            NSMutableArray *words = [NSMutableArray arrayWithArray:[trimmedString componentsSeparatedByCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]]];
            int i = 0;
            for (NSString *word in words) {
                if (i == 0) {
                    stemString = [NSString stringWithFormat:@"%@", [word stem]];
                    i++;
                }
                else {
                    stemString = [NSString stringWithFormat:@"%@ %@", stemString, [word stem]];
                }
            }
        }
        else {
            NSLog(@"Regex error.");
        }
    }
    return stemString;
}

@end
