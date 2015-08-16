//
//  MainViewController.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "MainViewController.h"
#import "Reachability.h"
#import "YAMAuthenticationService.h"
#import "YAMResourceManager.h"
#import "YAMInstagramManager.h"

@interface MainViewController () <UIWebViewDelegate, YAMInstagramManagerDelegate>{
    
    Reachability* networkReachabitily;
    BOOL networkIsReachable;
    YAMAuthenticationService* authService;
    YAMResourceManager* resourceManager;
    YAMInstagramManager* instagramManager;
    
    int currentImageNumber;
    
}
// auth controls
@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *loginContainer;
@property (weak, nonatomic) IBOutlet UIWebView *authWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// browser controls
@property (weak, nonatomic) IBOutlet UIView *browserContainer;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadPhotoIndicator;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *imageCounterLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    networkIsReachable = NO;
    networkReachabitily = [Reachability reachabilityForInternetConnection];
    [networkReachabitily startNotifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    networkIsReachable = [networkReachabitily currentReachabilityStatus] != NotReachable;
    [self setLoginState];
    }

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self authenticate];

}

#pragma mark - Authentication


- (void) authenticate{
    
    authService = [[YAMAuthenticationService alloc] initWithAuthenticationConfigurator:[YAMApiConfigurator authenticationConfigurator]];
    if (networkReachabitily) {
        
        self.loginStatusLabel.text = @"Авторизация на Instagram...";
        self.authWebView.delegate = self;
        [self.authWebView loadRequest:authService.authenticationURLRequest];
        self.authWebView.alpha = 1.f;
        
    } else {
        
        self.loginStatusLabel.text = @"No Internet Connection";

    }
    
}

#pragma mark - YAMInstagramManagerDelegate

- (void)loadMediaForUserFinished{
    
    currentImageNumber = 0;
    self.previousButton.hidden = YES;
    self.nextButton.hidden = NO;
    [self loadInfoForCurrentImageNumber];
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:kInstagramAPIRedirectUri])
    {
        [self.activityIndicator startAnimating];
        
        NSArray *componentsURL = [request.URL.absoluteString componentsSeparatedByString:@"?code="];
        NSString *responseCode = componentsURL[1];
        
        if (responseCode) {
            self.authWebView.alpha = 0;
            [authService requestAccessTokenWithResponseCode:responseCode success:^(NSURLSessionDataTask *task, NSString *accessToken) {
                [self.activityIndicator stopAnimating];
                if (accessToken) {
                    self.loginStatusLabel.text = @"Authentication success! :)";
                    [self loadUserInfo];
                } else {
                    self.loginStatusLabel.text = @"Authentication failed... :(";
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Error with description = %@",error.description);
            }];
        }
    }
    
    return YES;
}

#pragma mark - Browser Methods

- (IBAction)logoutTapped:(id)sender {
    
    [CredentialStorage clearCookies];
    [CredentialStorage resetAccessToken];
    [self setLoginState];
    [self authenticate];
}


- (void) loadUserInfo{
    
    resourceManager = [[YAMResourceManager alloc]init];
    [resourceManager userInfoWithID:[CredentialStorage currentAuthenticatedUserID] success:^(YAMUser* userInfo) {
        instagramManager = [[YAMInstagramManager alloc]initWithUserInfo:userInfo];
        instagramManager.delegate = self;
        [instagramManager loadDataForUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.fullNameLabel.text = [instagramManager fullName];
            self.browserContainer.hidden = NO;
            self.loginContainer.hidden = YES;
            
        });
        [self setLoadingDataState];
        
    } failure:^(NSError *error) {
        NSLog(@"Get user info error - %@",error.description);
    }];
    
}

- (void)setLoginState{
    
    [self.activityIndicator startAnimating];
    self.loginStatusLabel.text = @"Проверка доступности сети...";
    self.loginContainer.hidden = NO;
    self.browserContainer.hidden = YES;
    
}

- (void) setLoadingDataState{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.photoView.image = nil;
        self.photoView.backgroundColor = [UIColor darkGrayColor];
        [self.loadPhotoIndicator startAnimating];
        self.commentsCountLabel.text = @"Loading...";
        self.previousButton.hidden = YES;
        self.nextButton.hidden = YES;
        
        
    });
    
}
- (IBAction)previusTapped:(id)sender {
    
    currentImageNumber--;
    [self setButtonsVisibility];
    [self loadInfoForCurrentImageNumber];
    
}
- (IBAction)nextTapped:(id)sender {
    
    currentImageNumber++;
    [self setButtonsVisibility];
    [self loadInfoForCurrentImageNumber];
}

- (void) setButtonsVisibility{
    
    self.nextButton.hidden = currentImageNumber == instagramManager.mediaCount-1;
    self.previousButton.hidden = currentImageNumber == 0;
    
}

- (void)loadInfoForCurrentImageNumber{
    
    self.imageCounterLabel.text = [NSString stringWithFormat:@"%i / %i",currentImageNumber+1,instagramManager.mediaCount];
    [self.loadPhotoIndicator startAnimating];
    [instagramManager getImageForIndex:currentImageNumber onSuccess:^(UIImage* image) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int commentsCount = [instagramManager getCommentsCountForIndex:currentImageNumber];
            self.commentsCountLabel.text = [NSString stringWithFormat:@"%i",commentsCount];
            self.photoView.image = image;
            [self.loadPhotoIndicator stopAnimating];
        });

        
    }];
    
}

@end
