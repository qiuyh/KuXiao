//
//  LearningContentCtl.h
//  rcpi
//
//  Created by wu on 15/10/21.
//  Copyright © 2015年 Dyang. All rights reserved.

#import <MediaPlayer/MediaPlayer.h>
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
@interface LearningContentCtl : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (weak, nonatomic) IBOutlet UIButton *teacherBtn;
@property (weak, nonatomic) IBOutlet UIButton *notesBtn;
@property (nonatomic,strong)WKWebView *wkView;
@property (nonatomic,strong)MPMoviePlayerController *mpCtl;
@property (nonatomic,assign)CGPoint currentPoint;

@property (nonatomic,strong)NSString *courseID;   //课程ID
@property (nonatomic,strong)NSString *targetID;   //章节ID
@property (nonatomic,strong)NSString *tokenID;    //登陆ID
@property (nonatomic,assign)BOOL hidden;

//test
- (IBAction)goToGroup:(UIButton *)sender;
- (IBAction)goToTeacher:(UIButton *)sender;
- (IBAction)goToNotes:(UIButton *)sender;
//菜单栏按钮
- (void)goToList:(UIButton *)sender;
- (void)getBack:(UIButton *)sender;
- (void)goToNews:(UIButton *)sender;
- (void)goToEvaluate:(UIButton *)sender;
-(void)closeWindow;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation;
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
- (void)openThePractise:(NSArray*)practise;
- (void)openTheLink:(NSString*)link;
-(void)openTheVideo:(NSString *)video;
-(void)openThePhoto:(NSString*)photo;
- (void)openThePPT:(NSArray*)ppt;

@end
