//
//  PinyinConversion.m
//
//  Created by Wieland Morgenstern on 15.11.12.
//
//

#import "PinyinConversion.h"

NSDictionary *substitutions;

@implementation PinyinConversion

+ (void)initialize {
    substitutions = @{
                     @"a": @[@"ā", @"á", @"ǎ", @"à"],
                     @"ɑ": @[@"ā", @"á", @"ǎ", @"à"],
                     @"e": @[@"ē", @"é", @"ě", @"è"],
                     @"i": @[@"ī", @"í", @"ǐ", @"ì"],
                     @"o": @[@"ō", @"ó", @"ǒ", @"ò"],
                     @"u": @[@"ū", @"ú", @"ǔ", @"ù"],
                     @"ü": @[@"ǖ", @"ǘ", @"ǚ", @"ǜ"],
                     @"v": @[@"ǖ", @"ǘ", @"ǚ", @"ǜ"],

                     @"A": @[@"Ā", @"Á", @"Ǎ", @"À"],
                     @"E": @[@"Ē", @"É", @"Ě", @"È"],
                     @"I": @[@"Ī", @"Í", @"Ĭ", @"Ì"],
                     @"O": @[@"Ō", @"Ó", @"Ǒ", @"Ò"],
                     @"U": @[@"Ū", @"Ú", @"Ǔ", @"Ù"],
                     @"Ü": @[@"Ǖ", @"Ǘ", @"Ǚ", @"Ǜ"],
                     @"V": @[@"Ǖ", @"Ǘ", @"Ǚ", @"Ǜ"],
                     };
}

// place the tonemark
+ (NSString *)pinyin:(NSString *)word vowel:(NSUInteger)vowelIndex tone:(NSUInteger)tone {

    NSRange vowelRange = NSMakeRange(vowelIndex, 1);
    NSString *vowel = [word substringWithRange:vowelRange];

    NSString *replacement = nil;
    
    if (tone > 0 && tone <= 5) {
        replacement = substitutions[vowel][tone - 1];
    }

    if (!replacement) {
        return word;
    }
    return [word stringByReplacingCharactersInRange:vowelRange withString:replacement];
}

+ (NSString *)convertWord:(NSString *)word {
    // search word backwards for the first digit
    NSRange foundRange = [word rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet
                                               options:NSBackwardsSearch];

    if (foundRange.location == NSNotFound) {
        return word;
    }

    if (foundRange.location < word.length - 1) {
        // the suffix might contain punctuation ("nü3;")
        NSString *suffix = [word substringFromIndex:foundRange.location + 1];

        // but if it contains letters it's not a valid pinyin string ("n3e")
        if ([suffix rangeOfCharacterFromSet:NSCharacterSet.letterCharacterSet].location != NSNotFound) {
            return word;
        }
    }

    NSInteger number = [word substringFromIndex:foundRange.location].integerValue;

    // fifth tone: neutral
    if (number == 5) {
        return word;
    }

    // 1. If there is an "a" or an "e", it will take the tone mark.
    NSUInteger location = [word rangeOfString:@"a" options:NSCaseInsensitiveSearch].location;
    if (location == NSNotFound) {
        location = [word rangeOfString:@"e" options:NSCaseInsensitiveSearch].location;
    }

    // 2. If there is an "ou", then the "o" takes the tone mark.
    if (location == NSNotFound) {
        location = [word rangeOfString:@"ou" options:NSCaseInsensitiveSearch].location;
    }

    // 3. Otherwise, the second vowel takes the tone mark.
    if (location == NSNotFound) {
        NSCharacterSet *pinyinVowels = [NSCharacterSet characterSetWithCharactersInString:@"aɑeiouüv"];
        location = [word rangeOfCharacterFromSet:pinyinVowels options:NSBackwardsSearch|NSCaseInsensitiveSearch].location;
    }

    if (location == NSNotFound) {
        return word;
    }

    NSString *tonedWord = [self pinyin:word vowel:location tone:number];
    if ([tonedWord isEqualToString:word]) {
        return word;
    }else{
        return [tonedWord stringByReplacingCharactersInRange:foundRange withString:@""];
    }
}

+ (NSString *)convertPinyin:(NSString *)pinyin {
    NSArray *words = [pinyin componentsSeparatedByCharactersInSet:
                      NSCharacterSet.whitespaceAndNewlineCharacterSet];

    NSMutableArray *convertedWords = [NSMutableArray arrayWithCapacity:words.count];

    [words enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [convertedWords addObject:[self convertWord:obj]];
    }];

    return [convertedWords componentsJoinedByString:@" "];
}

@end
