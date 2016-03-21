//
//  ViewController.m
//  SearchHistoryDemo
//
//  Created by Lzq on 16/3/6.
//  Copyright © 2016年 Lzq. All rights reserved.
//

#import "ChineseInclude.h"

@implementation ChineseInclude
+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end
