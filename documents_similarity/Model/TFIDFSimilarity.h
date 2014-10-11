//
//  TFIDFSimilarity.h
//  documents_similarity
//
//  Created by Aleksander Grzyb on 10/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFIDFSimilarity : NSObject

+ (NSArray *)calculateScoresForDocuments:(NSArray *)documents keywords:(NSArray *)keywords andQuery:(NSString *)query;

@end
