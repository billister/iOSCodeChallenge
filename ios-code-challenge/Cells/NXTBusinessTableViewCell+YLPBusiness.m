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
    self.nameLabel.text = business.name;
    self.categoriesLabel.text = business.categoriesString;
    self.ratingLabel.text = business.ratingString;
    self.reviewCountLabel.text = business.reviewCountString;
    self.distanceLabel.text = business.distanceString;
    [self thumbnailImageDownload:business.thumbnailURL];
}

#pragma mark - NXTBindingDataForObjectDelegate
- (void)bindingDataForObject:(id)object
{
    [self configureCell:(YLPBusiness *)object];
}

#pragma mark - helper methods

- (void)thumbnailImageDownload:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"forkKnife"];
    
    typeof(self) __weak weakSelf = self;
    [self.thumbnailImageView setImageWithURLRequest:request
                       placeholderImage:placeholderImage
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.thumbnailImageView.image = image;
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error){
        typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.thumbnailImageView.image = placeholderImage;
        }
    }];
}

@end
