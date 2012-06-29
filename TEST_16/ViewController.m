//
//  ViewController.m
//  TEST_16
//
//  Created by apple on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "HtmlString.h"

#define EMOJINUM 103

@interface ViewController ()

@end

@implementation ViewController
@synthesize webView = _webView;
@synthesize scrollerView = _scrollerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *str = [NSString stringWithFormat:@"%@", @"这是测试字符串 测试字[心]符串@对象 测试字[bed凌乱]符串#话题#测试字符串 http://t.cn/zWZraspD"];
    
    NSString *transformStr = [HtmlString transformString:str];
    
    NSString *newStr = [transformStr stringByAppendingFormat:@"<br /><img src='http://ww1.sinaimg.cn/thumbnail/6628711bjw1du3yg62r81j.jpg'>"];
        
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 20, 300, 350)];
    self.webView.delegate = self;
    
    self.webView.backgroundColor = [UIColor whiteColor];  //但是这个属性必须用代码设置，光 xib 设置不行
    self.webView.opaque = NO;
    
    //这行能在模拟器下明下加快 loadHTMLString 后显示的速度，其实在真机上没有下句也感觉不到加载过程
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [self.webView loadHTMLString:newStr baseURL:nil]; //在 WebView 中显示本地的字符串
    [self.view addSubview:self.webView];
}

- (void)showEmojiStr:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotion.plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    NSString *key = [NSString stringWithFormat:@"%d", button.tag];
    NSString *emojiStr = [m_EmojiDic objectForKey:key];
    NSLog(@"emojiStr:%@", emojiStr);
}

- (void)dealloc
{
    [_webView release];
    [_scrollerView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setScrollerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{ 
    NSLog(@"shouldStartLoadWithRequest");
    NSString *requestString = [[request URL] absoluteString];
    NSLog(@"urlString:%@", requestString);
    
    NSArray *urlComps = [requestString componentsSeparatedByString:@"&"];
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd1"])//@方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return YES;
    }
    
    if ([urlComps count] > 1 && [(NSString *)[urlComps objectAtIndex:1] isEqualToString:@"cmd2"])//话题方法
    {
        NSString *str = [[urlComps objectAtIndex:2] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return YES;
    }
    
    //以下是使用safri打开链接
    NSURL *requestURL =[ [ request URL ] retain ]; 
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ]) 
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) { 
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ]; 
    } 
    [ requestURL release ];
    
    return YES;
}

@end
