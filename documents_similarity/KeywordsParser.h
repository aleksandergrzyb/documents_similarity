//
//  KeywordsParser.h
//  documents_similarity
//
//  Created by Aleksander Grzyb on 10/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeywordsParser : NSObject

- (NSArray *)parseKeywordsFromFilePath:(NSString *)filePath;

@end
