//
//  ViewController.m
//  Liquid
//
//  Created by Liquid Liquid Data Intelligence, S.A. (lqd.io) on 12/06/14.
//  Copyright (c) 2014 Liquid Data Intelligence, S.A. All rights reserved.
//

#import "ViewController.h"
#import "Liquid.h"
#import "NSDateFormatter+LQDateFormatter.h"
#import "UIColor+LQColor.h"

@interface ViewController ()

@property (nonatomic, strong, readonly) NSDictionary *userProfiles;
@property (nonatomic, strong) NSString *selectedUserProfile;

@end

@implementation ViewController

NSString *const defaultTitle = @"Welcome to our app";
NSString *const defaultBgColor = @"#FF0000";
NSString *const defaultPromoDay = @"2014-05-11T15:17:03.103+0100";
NSInteger const defaultloginVersion = 3;
CGFloat const defaultDiscount = 0.15f;
BOOL const defaultShowAds = YES;

@synthesize userProfiles = _userProfiles;

#pragma mark - Initializers

- (NSDictionary *)userProfiles {
    if (!_userProfiles) {
        NSDictionary *user1Attributes = @{ @"name":@"Anna Anna", @"age":@"25", @"gender":@"female" };
        NSDictionary *user2Attributes = @{ @"name":@"John John", @"age":@"37", @"gender":@"male" };
        NSDictionary *user3Attributes = @{ @"name":@"Barry Barry", @"age":@"16", @"gender":@"male" };
        NSDictionary *user4Attributes = @{ @"name":@"Chris Chris", @"age":@"54", @"gender":@"female" };
        _userProfiles = [NSDictionary dictionaryWithObjectsAndKeys:user1Attributes, @"100",
                         user2Attributes, @"101", user3Attributes, @"102", user4Attributes, @"103", nil];
    }
    return _userProfiles;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
    [[Liquid sharedInstance] setDelegate:self];

    // Pre-select User with identifier "100":
    self.selectedUserProfile = @"100";
    [self.userSelectorSegmentedControl setSelectedSegmentIndex:0];
    [self setCurrentUserWithIdentifier:self.selectedUserProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - UI Elements Actions

- (IBAction)resetSDKButtonPressed:(id)sender {
    [[Liquid sharedInstance] softReset];
}

- (IBAction)flushHTTPRequestsButtonPressed:(id)sender {
    [[Liquid sharedInstance] flush];
}

- (IBAction)trackEvent1:(id)sender {
    [[Liquid sharedInstance] track:@"Buy Product" attributes:@{
                                                               @"productId": @40,
                                                               @"price": @30.5,
                                                               @"withDiscount": @YES
                                                               }];
    NSLog(@"Track 'Buy Product' event");
}

- (IBAction)trackEvent2:(id)sender {
    [[Liquid sharedInstance] track:@"Play Music" attributes:@{
                                                              @"artist": @"Bee Gees",
                                                              @"track": @"Stayin' Alive",
                                                              @"album": @"Saturday Night Fever",
                                                              @"releaseYear": @1977
                                                              }];
    NSLog(@"Track 'Play Music' event");
}

- (IBAction)trackEvent3:(id)sender {
    [[Liquid sharedInstance] track:self.customEventNameTextField.text];
    
    NSLog(@"Track '%@' event", self.customEventNameTextField.text);
}

- (IBAction)requestValuesButtonPressed:(id)sender {
    [[Liquid sharedInstance] requestValues];
}

- (IBAction)loadValuesButtonPressed:(id)sender {
    [[Liquid sharedInstance] loadValues];
}


#pragma mark - Demo App methods

- (void)refrehInformation {
    NSString *title = [[Liquid sharedInstance] stringForKey:@"title" fallback:defaultTitle];
    NSDate *promoDay = [[Liquid sharedInstance] dateForKey:@"promoDay" fallback:[NSDateFormatter dateFromISO8601String:defaultPromoDay]];
    UIColor *bgColor = [[Liquid sharedInstance] colorForKey:@"textcolor" fallback:[UIColor colorFromHexadecimalString:defaultBgColor]];
    NSInteger loginVersion = [[Liquid sharedInstance] intForKey:@"login" fallback:defaultloginVersion];
    CGFloat discount = [[Liquid sharedInstance] floatForKey:@"discount" fallback:defaultDiscount];
    BOOL showAds = [[Liquid sharedInstance] boolForKey:@"showAds" fallback:defaultShowAds];
    
    self.bgColorLabel.text = [UIColor hexadecimalStringFromUIColor:bgColor];
    self.bgColorSquare.backgroundColor = bgColor;
    self.showAdsLabel.text = (showAds ? @"yes" : @"no");
    self.titleLabel.text = title;
    
    NSLog(@"title: %@", title);
    NSLog(@"promoDay: %@", promoDay);
    NSLog(@"bgColor: %@", bgColor);
    NSLog(@"loginVersion: %d", (int)loginVersion);
    NSLog(@"discount: %f", discount);
    NSLog(@"showAds: %@", (showAds ? @"yes" : @"no"));
}

- (void)setCurrentUserWithIdentifier:(NSString *)userIdentifier {
    NSDictionary *userAttributes = [self.userProfiles objectForKey:userIdentifier];
    [[Liquid sharedInstance] identifyUserWithIdentifier:userIdentifier attributes:userAttributes];
    self.selectedUserProfile = userIdentifier;
    NSLog(@"Current user is now '%@', with attributes: %@", userIdentifier, userAttributes);
}


#pragma mark - Liquid Delegate methods

- (void)liquidDidReceiveValues {
    if (self.autoLoadValuesSwitch.on) {
        [[Liquid sharedInstance] loadValues];
    }
    NSLog(@"Received new values from Liquid Server. They were stored in cache, waiting to be loaded.");
}

- (void)liquidDidLoadValues {
    [self refrehInformation];
    NSLog(@"Cached alues were lodade into memory.");
}


#pragma mark - Delegate methods: UITableViewDelegate, UITableViewDataSource

- (IBAction)profileSelectorPressed:(UISegmentedControl *)sender {
    [self setCurrentUserWithIdentifier:[NSString stringWithFormat:@"%d", (int) (100 + sender.selectedSegmentIndex)]];
    [self.userAttributesTableView reloadData];
}

 
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    if (tableView.tag == 1) return [[self.userProfiles objectForKey:self.selectedUserProfile] count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *key = @"";
    NSString *value = @"";
    
    if (tableView.tag == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
        key = [[[self.userProfiles objectForKey:self.selectedUserProfile] allKeys] objectAtIndex:indexPath.row];
        value = [[self.userProfiles objectForKey:self.selectedUserProfile] objectForKey:key];
    }
    cell.textLabel.text = key;
    cell.detailTextLabel.text = value;

    return cell;
}

@end