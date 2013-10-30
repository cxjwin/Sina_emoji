//
//  ViewController.m
//  TEST_16
//
//  Created by apple on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "NSString+HTML.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // String 
    NSString *str = 
    @"这是测试字符串 测试字[心]符串@对象 测试字[bed凌乱]符串#话题#测试字符串 http://t.cn/zWZraspD";
    
    NSString *transformStr = [NSString transformString:str];
    
    NSString *newStr = 
    [transformStr stringByAppendingFormat:@"<br><img src='http://ww1.sinaimg.cn/thumbnail/6628711bjw1du3yg62r81j.jpg'></br>"];
    
    // WebView
    CGRect frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 20);
    self.webView = [[[UIWebView alloc] initWithFrame:frame] autorelease];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.webView loadHTMLString:newStr baseURL:nil];
    [self.view addSubview:self.webView];
    
}

- (void)dealloc
{
    [_webView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
    NSURL *URL = [request URL];
    NSString *component = [URL lastPathComponent];
    NSLog(@"component : %@", component);
    
    if (component) {
        
        if ([component hasPrefix:@"at"]) {// at
            NSString *str = [component substringWithRange:NSMakeRange(2, [component length] - 2)];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return NO;
        } else if ([component hasPrefix:@"topic"]) {// topic
            NSString *str = [component substringWithRange:NSMakeRange(5, [component length] - 5)];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            return NO;
        }

    }
        
    NSURL *requestURL = [[request URL] retain]; 
    if (([[requestURL scheme ] isEqualToString: @"http"]    || 
         [[requestURL scheme ] isEqualToString: @"https"]   || 
         [[requestURL scheme ] isEqualToString: @"mailto"]) &&
        (navigationType == UIWebViewNavigationTypeLinkClicked)) { 
        return ![[UIApplication sharedApplication] openURL:[requestURL autorelease]]; 
    } 
    [requestURL release];
        
    
    return YES;
}

@end
