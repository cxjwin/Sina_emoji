//
//  NSString+HTML.m
//  Sina_emoji
//
//  Created by cxjwin on 13-10-30.
//
//

#import "NSString+HTML.h"
#import "RegexKitLite.h"

@implementation NSString (HTML)

+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;
    
    //解析http://短链接
    NSString *regex_http = @"[http]+://[a-zA-Z].[a-zA-Z]*/[a-zA-Z]*";//http://短链接正则表达式
    NSArray *array_http = [text componentsMatchedByRegex:regex_http];
    
    if ([array_http count]) {
        for (NSString *str in array_http) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href='%@'>%@</a>",str, str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length) withString:funUrlStr];
            NSLog(@"text:%@", text);
        }
    }
    
    //解析@
    NSString *regex_at = @"@[\\u4e00-\\u9fa5\\w\\-]+";//@的正则表达式
    NSArray *array_at = [text componentsMatchedByRegex:regex_at];
    
    if ([array_at count]) {
        NSMutableArray *test_arr = [[NSMutableArray alloc] init];
        for (NSString *str in array_at) {
            NSRange range = [text rangeOfString:str];
            if (![test_arr containsObject:str]) {
                [test_arr addObject:str];
                NSString *funUrlStr = [NSString stringWithFormat:@"<a href='at%@'>%@</a>", [str substringWithRange:NSMakeRange(1, [str length] - 1)], str];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
                NSLog(@"text:%@", text);
            }
        }
        [test_arr release];
    }
    
    //解析话题
    NSString *regex_pound = @"#([^\\#|.]+)#";//话题的正则表达式
    NSArray *array_pound = [text componentsMatchedByRegex:regex_pound];
    
    if ([array_pound count]) {
        for (NSString *str in array_pound) {
            NSRange range = [text rangeOfString:str];
            NSString *funUrlStr = [NSString stringWithFormat:@"<a href='topic%@'>%@</a>",[str substringWithRange:NSMakeRange(1, [str length] - 2)], str];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:funUrlStr];
            NSLog(@"text:%@", text);
        }
    }
    
    //解析表情
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";//表情的正则表达式
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emotionImage" ofType:@"plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
    
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
            if (i_transCharacter) {
                NSString *imageHtml = [NSString stringWithFormat:@"<img src = 'file://%@/%@' width='16' height='16'>", path, i_transCharacter];           
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    
    //返回转义后的字符串
    return text;
}

@end
