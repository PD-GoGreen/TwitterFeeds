//
//  FeedTableViewCell.h
//  TwitterFeeds
//
//  Created by Pradnya on 10/16/14.
//  Copyright (c) 2014 Pradnya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@end
