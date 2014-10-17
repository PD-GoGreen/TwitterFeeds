//
//  TwitterFeedsTests.m
//  TwitterFeedsTests
//
//  Created by Pradnya on 10/15/14.
//  Copyright (c) 2014 Pradnya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Feed.h"
#import "FeedsViewController.h"

@interface FeedTestCase : XCTestCase

@property (nonatomic, strong) FeedsViewController *vc;
@property (nonatomic, strong)Feed *feed;

@end

@implementation FeedTestCase

- (void)setUp {
    [super setUp];
    
    self.vc = [[FeedsViewController alloc] init];
    self.feed = [[Feed alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.vc = nil;
    self.feed = nil;
    [super tearDown];
}

-(void)testViewLoad {
    XCTAssertNotNil(self.vc.view, @"View not initiated properly for FeedsViewController");
}

-(void)testTableViewLoad {
    XCTAssertNotNil(self.vc.tableView, @"TableView not initiated for FeedsViewController");
}

- (void)testViewConformsToUITableViewDataSource {
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testTableViewHasDataSource {
    XCTAssertNotNil(self.vc.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testViewConformsToUITableViewDelegate {
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate {
    XCTAssertNotNil(self.vc.tableView.delegate, @"Table delegate cannot be nil");
}

- (void)testSetterScreenName {
    // This is an example of a functional test case.
    self.feed.screenName = @"testScreenName";
    XCTAssertNotNil(self.feed.screenName, @"setter for ScreenName not working");
    
}

- (void)testSetterText {
    self.feed.text = @"testText";
    XCTAssertNotNil(self.feed.text, @"setter for text not working");
    
}

- (void)testCreateDate {
    self.feed.createDate = @"testCreateDate";
    XCTAssertNotNil(self.feed.createDate, @"setter for createDate not working");
    
}

- (void)testSetteFeedID {
    self.feed.feedID = @"testFeedID";
    XCTAssertNotNil(self.feed.feedID, @"setter for feedID not working");
    
}

@end
