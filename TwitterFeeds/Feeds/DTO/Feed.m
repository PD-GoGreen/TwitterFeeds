//
//  Feed.m
//  TwitterFeeds
//
//  Created by Pradnya on 10/16/14.
//  Copyright (c) 2014 Pradnya. All rights reserved.
//

#import "Feed.h"

@interface Feed ()

@end

@implementation Feed

- (instancetype)initWithDictionary:(NSDictionary*)response{
    
    self = [super init];
    
    if (self) {
        
        if ([response valueForKey:@"text"]) {
            self.text = [response valueForKey:@"text"];
        }
        
        if ([response valueForKey:@"user"]) {
            
            if ([[response valueForKey:@"user"] valueForKey:@"screen_name"]) {
                self.screenName = [[response valueForKey:@"user"] valueForKey:@"screen_name"];
            }
        }
        
        if ([response valueForKey:@"created_at"]) {
            self.createDate = [response valueForKey:@"created_at"];
        }
        
        if ([response valueForKey:@"id_str"]) {
            self.feedID = [response valueForKey:@"id_str"];
        }

    }
    return self;

}



@end
