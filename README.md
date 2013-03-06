pinyin-conversion
=================

Convert pinyin strings from numerical form (ni3 hao3) to a diacritical form (nǐ hǎo)

About
=====

This code can be used to convert numerical pinyin strings to strings that place the tone mark over the vowel. It follows the [rules](http://en.wikipedia.org/wiki/Pinyin#Rules_for_placing_the_tone_mark) named in the wikipedia article on pinyin.

Usage
=====
    [PinyinConversion convertPinyin:@"ni3 hao3"]
      --> @"nǐ hǎo"

It is intended to be used with single words or word groups (input is separated by white spaces and joined by spaces after conversion).
