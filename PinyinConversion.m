//
//  PinyinConversion.m
//
//  Created by Wieland Morgenstern on 15.11.12.
//
//

#import "PinyinConversion.h"
#import "NSArray+Map.h"

NSDictionary *substitutions;

@implementation PinyinConversion

+ (void)initialize {
    substitutions = [@{
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
                     } retain];
}

// place the tonemark
+ (NSString *)pinyin:(NSString *)word vowel:(NSUInteger)vowelIndex tone:(NSUInteger)tone {

    NSRange vowelRange = NSMakeRange(vowelIndex, 1);
    NSString *vowel = [word substringWithRange:vowelRange];

    NSString *replacement = substitutions[vowel][tone - 1];

    if (!replacement) {
        return word;
    }
    return [word stringByReplacingCharactersInRange:vowelRange withString:replacement];
}

+ (NSString *)convertPinyin:(NSString *)pinyin {
    NSArray *words = [pinyin componentsSeparatedByCharactersInSet:
                      NSCharacterSet.whitespaceAndNewlineCharacterSet];

    NSArray *convertedWords = [words map:^id(NSString *word, NSUInteger idx) {

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

        // trim the pinyin number
        NSString *trimmedWord = [word stringByReplacingCharactersInRange:foundRange withString:@""];

        // fifth tone: neutral
        if (number == 5) {
            return trimmedWord;
        }

        // 1. If there is an "a" or an "e", it will take the tone mark.
        NSUInteger location = [trimmedWord rangeOfString:@"a" options:NSCaseInsensitiveSearch].location;
        if (location == NSNotFound) {
            location = [trimmedWord rangeOfString:@"e" options:NSCaseInsensitiveSearch].location;
        }

        // 2. If there is an "ou", then the "o" takes the tone mark.
        if (location == NSNotFound) {
            location = [trimmedWord rangeOfString:@"ou" options:NSCaseInsensitiveSearch].location;
        }

        // 3. Otherwise, the second vowel takes the tone mark.
        if (location == NSNotFound) {
            NSCharacterSet *pinyinVowels = [NSCharacterSet characterSetWithCharactersInString:@"aɑeiouüv"];
            location = [trimmedWord rangeOfCharacterFromSet:pinyinVowels options:NSBackwardsSearch|NSCaseInsensitiveSearch].location;
        }

        if (location == NSNotFound) {
            return trimmedWord;
        }

        return [self pinyin:trimmedWord vowel:location tone:number];
    }];

    return [convertedWords componentsJoinedByString:@" "];
}

@end
