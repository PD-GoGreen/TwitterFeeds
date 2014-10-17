//
//  Feed.h
//  TwitterFeeds
//
//  Created by Pradnya on 10/16/14.
//  Copyright (c) 2014 Pradnya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Feed : NSObject

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *feedID;

- (instancetype)initWithDictionary:(NSDictionary*)response;

@end
