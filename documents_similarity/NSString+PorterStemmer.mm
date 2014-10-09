//
//  NSString+PorterStemmer.m
//  documents_similarity
//
//  Created by Aleksander Grzyb on 08/10/14.
//  Copyright (c) 2014 Aleksander Grzyb. All rights reserved.
//

#import "NSString+PorterStemmer.h"
#import "porter2_stemmer.h"

@implementation NSString (PorterStemmer)

- (NSString *)stem
{
    std::string *word = new std::string([self UTF8String]);
    Porter2Stemmer::stem(*word);
    return [NSString stringWithCString:(*word).c_str() encoding:[NSString defaultCStringEncoding]];
}

@end

