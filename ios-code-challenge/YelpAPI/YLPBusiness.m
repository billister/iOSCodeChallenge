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
        
        NSNumber *metersToMilesConvertion = @0.000621;
        _identifier = attributes[@"id"];
        _name = attributes[@"name"];
        _price = attributes[@"price"];
        _categories = attributes[@"categories"];
        _rating = attributes[@"rating"];
        _reviewCount = attributes[@"review_count"];
        _distanceMiles = attributes[@"distance"];
        _distanceMiles = [NSNumber numberWithDouble:_distanceMiles.doubleValue * metersToMilesConvertion.doubleValue];
        _thumbnailURL = attributes[@"image_url"];
        

        _categoriesString = [self categoryTitles:_categories];
        _ratingString = [NSString stringWithFormat:@"Rating: %@", _rating];
        _reviewCountString = [NSString stringWithFormat:@"%@ reviews", _reviewCount.stringValue];
        _distanceString = [NSString stringWithFormat:@"%@ mi", [self roundDecimalToTwoPlaces:_distanceMiles]];
    }
    
    return self;
}

#pragma mark - helper methods
- (NSString*)roundDecimalToTwoPlaces:(NSNumber*)decimalNum
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    formatter.roundingMode = NSNumberFormatterRoundHalfEven;
    NSString *numberString = [formatter stringFromNumber:decimalNum];
    return numberString;
}

- (NSString*)categoryTitles:(NSArray*)tempCatArray
{
    NSString *returnString = @"";
    for(NSDictionary *dict in tempCatArray) {
        NSString *object = [dict objectForKey:@"title"];
        
        if([returnString isEqual:@""]) {
            returnString = object;
        } else {
            returnString = [NSString stringWithFormat:@"%@, %@", returnString, object];
        }
        
    }
    
    return returnString;
}

@end
