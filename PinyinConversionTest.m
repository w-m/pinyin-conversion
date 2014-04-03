//
//  PinyinConversionTest.m
//
//  Created by Wieland Morgenstern on 15.11.12.
//
//

#import "PinyinConversionTest.h"

#import "PinyinConversion.h"

@implementation PinyinConversionTest

- (void)testNoChange {

    STAssertEqualObjects(@"ma", [PinyinConversion convertPinyin:@"ma"], @"Should not change when there's no tone.");
    STAssertEqualObjects(@"ma ma hu hu", [PinyinConversion convertPinyin:@"ma ma hu hu"], @"Should not change when there's no tone.");

    STAssertEqualObjects(@"mā", [PinyinConversion convertPinyin:@"mā"], @"Should not change already converted pinyin.");
    STAssertEqualObjects(@"má", [PinyinConversion convertPinyin:@"má"], @"Should not change already converted pinyin.");
    STAssertEqualObjects(@"mǎ", [PinyinConversion convertPinyin:@"mǎ"], @"Should not change already converted pinyin.");
    STAssertEqualObjects(@"mà", [PinyinConversion convertPinyin:@"mà"], @"Should not change already converted pinyin.");

    STAssertEqualObjects(@"pi4an", [PinyinConversion convertPinyin:@"pi4an"], @"Strings that contain numbers but are invalid pinyin string should not change");

    STAssertEqualObjects(@"23", [PinyinConversion convertPinyin:@"23"], @"Should not change numbers.");

    STAssertEqualObjects(@"ma0", [PinyinConversion convertPinyin:@"ma0"], @"Should ignore words with non-pinyin numbers.");
    STAssertEqualObjects(@"ma6", [PinyinConversion convertPinyin:@"ma6"], @"Should ignore words with non-pinyin numbers.");
}

- (void)testA {
    STAssertEqualObjects(@"mā", [PinyinConversion convertPinyin:@"ma1"], @"Converting first tone");
    STAssertEqualObjects(@"má", [PinyinConversion convertPinyin:@"ma2"], @"Converting second tone");
    STAssertEqualObjects(@"mǎ", [PinyinConversion convertPinyin:@"ma3"], @"Converting third tone");
    STAssertEqualObjects(@"mà", [PinyinConversion convertPinyin:@"ma4"], @"Converting fourth tone");
    STAssertEqualObjects(@"ma", [PinyinConversion convertPinyin:@"ma5"], @"Converting fifth tone");
}

- (void)testNiHao {
    STAssertEqualObjects(@"nǐ hǎo", [PinyinConversion convertPinyin:@"ni3 hao3"], @"Hello!");
}

- (void)testPunctuationMarks {
    STAssertEqualObjects(@"piàn;", [PinyinConversion convertPinyin:@"pian4;"], @"Converting with a punctuation mark after the word");
}

- (void)testMultipleWords {
    STAssertEqualObjects(@"dòng huà piàn dòng huà piān",
                         [PinyinConversion convertPinyin:@"dong4 hua4 pian4 dong4 hua4 pian1"],
                         @"Converting multiple words at once");
}

@end
