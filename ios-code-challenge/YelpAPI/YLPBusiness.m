//
//  YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPBusiness.h"

@implementation YLPBusiness

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if(self = [super init]) {
        _identifier = attributes[@"id"];
        _name = attributes[@"name"];
        _categories = attributes[@"categories"];
        _rating = attributes[@"rating"];
        _reviewCount = attributes[@"review_count"];
        _distance = attributes[@"distance"];
        _thumbnailURL = attributes[@"image_url"];
    }
    
    return self;
}

@end
