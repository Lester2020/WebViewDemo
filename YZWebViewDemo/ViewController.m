//
//  ViewController.m
//  YZWebViewDemo
//
//  Created by Lester 's Mac on 2021/8/31.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *demoHtml;
@property (nonatomic, copy) NSString *theme1Css;
@property (nonatomic, copy) NSString *theme2Css;
@property (nonatomic, copy) NSString *theme3Css;
@property (nonatomic, copy) NSString *themeModeJs;
@property (nonatomic, assign) int count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    
    NSString *demoHTMLFile = [[NSBundle mainBundle] pathForResource:@"demoHtml" ofType:@"html"];
    self.demoHtml = [NSString stringWithContentsOfFile:demoHTMLFile encoding:NSUTF8StringEncoding error:nil];
    
    NSString *css1File = [[NSBundle mainBundle] pathForResource:@"Theme1" ofType:@"css"];
    self.theme1Css = [NSString stringWithContentsOfFile:css1File encoding:NSUTF8StringEncoding error:nil];
    
    NSString *css2File = [[NSBundle mainBundle] pathForResource:@"Theme2" ofType:@"css"];
    self.theme2Css = [NSString stringWithContentsOfFile:css2File encoding:NSUTF8StringEncoding error:nil];
    
    NSString *css3File = [[NSBundle mainBundle] pathForResource:@"Theme3" ofType:@"css"];
    self.theme3Css = [NSString stringWithContentsOfFile:css3File encoding:NSUTF8StringEncoding error:nil];
    
    NSString *jsFile = [[NSBundle mainBundle] pathForResource:@"ThemeMode" ofType:@"js"];
    self.themeModeJs = [NSString stringWithContentsOfFile:jsFile encoding:NSUTF8StringEncoding error:nil];
    
    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    
    WKUserScript *script1 = [[WKUserScript alloc] initWithSource:self.themeModeJs injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [contentController addUserScript:script1];
    
    NSString *escapedCSS = [[NSString stringWithFormat:@"\"%@\"", self.theme1Css] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *javaScript = [NSString stringWithFormat:@"initCSS(%@)", escapedCSS];
    WKUserScript *script2 = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [contentController addUserScript:script2];
    
    webConfiguration.userContentController = contentController;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfiguration];
    [self.view addSubview:self.webView];
    
    [self.webView loadHTMLString:self.demoHtml baseURL:nil];
    
    self.title = @"WebView Demo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换模式" style:UIBarButtonItemStylePlain target:self action:@selector(changeMode)];
    
    
}

- (void)changeMode {
    self.count++;
    if (self.count > 3) {
        self.count = 1;
    }
    
    NSString *css;
    if (self.count == 1) {
        css = self.theme1Css;
    } else if (self.count == 2) {
        css = self.theme2Css;
    } else if (self.count == 3) {
        css = self.theme3Css;
    }
    
    NSString *escapedCSS = [[NSString stringWithFormat:@"\"%@\"", css] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *javaScript = [NSString stringWithFormat:@"initCSS(%@)", escapedCSS];
    
    [self.webView evaluateJavaScript:javaScript completionHandler:^(id handle, NSError * _Nullable error) {
        
    }];
    
}


@end
