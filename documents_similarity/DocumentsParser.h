//
//  DocumentsParser.h
//  documents_similarity
//
//  Created by Aleksander Grzyb on 05/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentsParser : NSObject

- (NSArray *)parseDocumentFromFilePath:(NSString *)filePath;

@end
