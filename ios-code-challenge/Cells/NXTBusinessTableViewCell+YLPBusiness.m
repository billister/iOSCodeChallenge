//
//  NXTBusinessTableViewCell+YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "NXTBusinessTableViewCell+YLPBusiness.h"
#import "UIImageView+AFNetworking.h"
#import "YLPBusiness.h"


@implementation NXTBusinessTableViewCell (YLPBusiness) 

- (void)configureCell:(YLPBusiness *)business
{
    [self thumbnailImageDownload:business.thumbnailURL];
    // Business Name
    self.nameLabel.text = business.name;
    self.categoriesLabel.text = [self categoryTitles:business.categories];
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating: %@", business.rating.stringValue];
    self.reviewCountLabel.text = [NSString stringWithFormat:@"%@ reviews", business.reviewCount.stringValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ mi", [self roundDecimalToTwoPlaces:business.distance]];
}

#pragma mark - NXTBindingDataForObjectDelegate
- (void)bindingDataForObject:(id)object
{
    [self configureCell:(YLPBusiness *)object];
}

#pragma mark - helper methods
- (NSString*)roundDecimalToTwoPlaces:(NSNumber*)decimalNum
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    formatter.roundingMode = NSNumberFormatterRoundUp;
    NSString *numberString = [formatter stringFromNumber:decimalNum];
    return numberString;
}

- (void)thumbnailImageDownload:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"forkKnife"];
    
    [self.thumbnailImageView setImageWithURLRequest:request
                       placeholderImage:placeholderImage
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.thumbnailImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error){
        self.thumbnailImageView.image = placeholderImage;
    }];
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
