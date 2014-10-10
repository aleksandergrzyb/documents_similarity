//
//  DocumentsParser.h
//  documents_similarity
//
//  Created by Aleksander Grzyb on 05/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOCUMENTS_TITLE_KEY @"Title"
#define DOCUMENTS_STEMMED_BODY_KEY @"Body"
#define DOCUMENTS_SCORE_KEY @"Score"

@interface DocumentsParser : NSObject

- (NSArray *)parseDocumentFromFilePath:(NSString *)filePath;

@end
