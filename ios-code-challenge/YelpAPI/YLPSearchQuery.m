//
//  YLPSearchQuery.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPSearchQuery.h"

@interface YLPSearchQuery()

@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSNumber *limit;
@property (nonatomic, copy) NSNumber *offset;

@end

@implementation YLPSearchQuery

- (instancetype)initWithLocation:(NSString *)location
{
    if(self = [super init]) {
        _location = location;
    }
    
    return self;
}

- (instancetype)initWithLatitude:(NSNumber *)latitude Longitude:(NSNumber*)longitude Limit:(NSNumber*)limit Offset:(NSNumber*)offset {
    
    if(self = [super init]) {
        _latitude = latitude;
        _longitude = longitude;
        _limit = limit;
        _offset = offset;
    }
    
    return self;
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(self.latitude) {
        params[@"latitude"] = self.latitude;
    }
    
    if(self.longitude) {
        params[@"longitude"] = self.longitude;
    }
    
    if(self.location) {
        params[@"location"] = self.location;
    }
    
    if(self.term) {
        params[@"term"] = self.term;
    }
    
    if(self.radiusFilter > 0) {
        params[@"radius"] = @(self.radiusFilter);
    }
    
    if(self.categoryFilter != nil && self.categoryFilter.count > 0) {
        params[@"categories"] = [self.categoryFilter componentsJoinedByString:@","];
    }
    
    if(self.limit) {
        params[@"limit"] = self.limit;
    }
    
    if(self.offset) {
        params[@"offset"] = self.offset;
    }
    
    return params;
}

- (NSArray<NSString *> *)categoryFilter {
    return _categoryFilter ?: @[];
}

@end
