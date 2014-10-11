//
//  TFIDFSimilarity.m
//  documents_similarity
//
//  Created by Aleksander Grzyb on 10/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import "TFIDFSimilarity.h"
#import "DocumentsParser.h"
#import "NSString+PorterStemmer.h"

@implementation TFIDFSimilarity

+ (NSArray *)calculateScoresForDocuments:(NSArray *)documents keywords:(NSArray *)keywords andQuery:(NSString *)query
{
    NSMutableArray *documentsWithCalculatedScores = [documents mutableCopy];
    if (documents.count > 0 && keywords.count > 0 && query && query.length > 0) {
        // Query stemming
        NSString *stemmedQuery = [TFIDFSimilarity stemmedQuery:query];
        
        // Query bag of words
        NSMutableArray *queryBagsOfWords = [NSMutableArray array];
        for (NSString *keyword in keywords) {
            NSArray *list = [stemmedQuery componentsSeparatedByString:keyword];
            unsigned long bagOfWord = [list count] - 1;
            [queryBagsOfWords addObject:@(bagOfWord)];
        }
        
        // Documents bag of words
        NSMutableArray *documentsBagsOfWords = [NSMutableArray array];
        for (int i = 0; i < documents.count; i++) {
            NSString *stemmedDocumentBody = documents[i][DOCUMENTS_STEMMED_BODY_KEY];
            [documentsBagsOfWords addObject:[NSMutableArray array]];
            for (NSString *keyword in keywords) {
                NSArray *list = [stemmedDocumentBody componentsSeparatedByString:keyword];
                unsigned long bagOfWord = [list count] - 1;
                [documentsBagsOfWords[i] addObject:@(bagOfWord)];
            }
        }
        
        // Query TF representation
        NSMutableArray *queryTFRepresentation = [TFIDFSimilarity normalize:queryBagsOfWords];
        
        // Documents TF Representation
        NSMutableArray *documentsTFRepresentation = [NSMutableArray array];
        for (int i = 0; i < documentsBagsOfWords.count; i++) {
            [documentsTFRepresentation addObject:[TFIDFSimilarity normalize:documentsBagsOfWords[i]]];
        }
        
        // IDF coefficients
        NSMutableArray *IDFCoefficients = [NSMutableArray array];
        for (int i = 0; i < keywords.count; i++) {
            int keywordCount = 0;
            for (int a = 0; a < documents.count; a++) {
                if (documents[a][i] > 0) {
                    keywordCount++;
                }
            }
            double IDFCoefficient = log10(documents.count / keywordCount);
            [IDFCoefficients addObject:[NSNumber numberWithDouble:IDFCoefficient]];
        }
        
        // Query TFIDF representation
        NSMutableArray *queryTFIDFRepresentation = [NSMutableArray array];
        for (int i = 0; i < keywords.count; i++) {
            double TFIDFRepresentation = [IDFCoefficients[i] doubleValue] * [queryTFRepresentation[i] doubleValue];
            [queryTFIDFRepresentation addObject:[NSNumber numberWithDouble:TFIDFRepresentation]];
        }
        
        // Documents TFIDF representation
        NSMutableArray *documentsTFIDFRepresentation = [NSMutableArray array];
        for (int i = 0; i < documents.count; i++) {
            [documentsTFIDFRepresentation addObject:[NSMutableArray array]];
            for (int a = 0; a < keywords.count; a++) {
                double TFIDFRepresentation = [IDFCoefficients[i] doubleValue] * [documentsTFRepresentation[i][a] doubleValue];
                [documentsTFIDFRepresentation[i] addObject:[NSNumber numberWithDouble:TFIDFRepresentation]];
            }
        }
        
        // Query length
        double queryLength = 0.0;
        for (int i = 0; i < queryTFIDFRepresentation.count; i++) {
            queryLength += pow([queryTFIDFRepresentation[i] doubleValue], 2.0);
        }
        queryLength = sqrt(queryLength);
        
        // Documents length
        NSMutableArray *documentsLength = [NSMutableArray array];
        for (int i = 0; i < documentsTFIDFRepresentation.count; i++) {
            double documentLength = 0.0;
            for (int a = 0; a < ((NSMutableArray *)documentsTFIDFRepresentation[i]).count; a++) {
                documentLength += pow([documentsTFIDFRepresentation[i][a] doubleValue], 2.0);
            }
            documentLength = sqrt(documentLength);
            [documentsLength addObject:[NSNumber numberWithDouble:documentLength]];
        }
        
        // Similarity values
        NSMutableArray *similarityValues = [NSMutableArray array];
        for (int i = 0; i < documents.count; i++) {
            double numerator = 0.0;
            for (int a = 0; a < keywords.count; a++) {
                numerator += [documentsTFIDFRepresentation[i][a] doubleValue] * [queryTFIDFRepresentation[a] doubleValue];
            }
            
            double similarityValue = 0.0;
            similarityValue = numerator / ([documentsLength[i] doubleValue] * queryLength);
            [similarityValues addObject:[NSNumber numberWithDouble:similarityValue]];
        }
        
        for (int i = 0; i < documents.count; i++) {
            documentsWithCalculatedScores[i][DOCUMENTS_SCORE_KEY] = similarityValues[i];
        }
    }
    return documentsWithCalculatedScores;
}

+ (NSMutableArray *)normalize:(NSMutableArray *)bagOfWords
{
    float maxiumum = 0;
    for (NSNumber *bagOfWord in bagOfWords) {
        if ([bagOfWord intValue] > maxiumum) {
            maxiumum = [bagOfWord intValue];
        }
    }
    NSMutableArray *normalizedBagOfWords = [NSMutableArray array];
    for (NSNumber *bagOfWord in bagOfWords) {
        float normalizedValue = [bagOfWord floatValue] / maxiumum;
        [normalizedBagOfWords addObject:[NSNumber numberWithFloat:normalizedValue]];
    }
    return normalizedBagOfWords;
}

+ (NSString *)stemmedQuery:(NSString *)query
{
    NSString *stemmedQuery = [query lowercaseString];
    stemmedQuery = [[stemmedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] componentsJoinedByString:@" "];
    stemmedQuery = [[stemmedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    stemmedQuery = [stemmedQuery stringByReplacingOccurrencesOfString:@"|" withString:@" "];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        stemmedQuery = [regex stringByReplacingMatchesInString:stemmedQuery options:0 range:NSMakeRange(0, [stemmedQuery length]) withTemplate:@" "];
        NSArray *nonStemmedWords = [NSArray arrayWithArray:[stemmedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]]];
        NSMutableArray *stemmedWords = [NSMutableArray array];
        for (NSString *nonStemmedWord in nonStemmedWords) {
            NSString *stemmedWord = [nonStemmedWord stem];
            [stemmedWords addObject:stemmedWord];
        }
        return [stemmedWords componentsJoinedByString:@" "];
    }
    return @"";
}

@end
