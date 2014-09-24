//
//  SearchResultCell.m
//  Yelp
//
//  Created by Peiqi Zheng on 9/21/14.
//  Copyright (c) 2014 Peiqi Zheng. All rights reserved.
//

#import "SearchResultCell.h"
#import "UIImageView+AFNetworking.h"

@interface SearchResultCell()

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;

@property (weak, nonatomic) IBOutlet UILabel *resultNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultDistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultRatingImage;
@property (weak, nonatomic) IBOutlet UILabel *resultCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultCategoryLabel;
@end

@implementation SearchResultCell

+ (NSString *)cellIdentifier {
    return @"SearchResultCell";
}

- (void)setSearchResult:(SearchResult *)searchResult withIndex:(NSInteger) index{
    _searchResult = searchResult;
    [self setCellWithIndex:index];
}

- (void)setCellWithIndex:(NSInteger) index{
    self.resultNameLabel.text = [NSString stringWithFormat:@"%lu. %@", index+1, self.searchResult.name];
    self.resultDistLabel.text = [NSString stringWithFormat:@"%.02f mi",self.searchResult.distance/1609];
    self.resultCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.searchResult.reviewCount];
    self.resultAddressLabel.text = self.searchResult.address;
    self.resultCategoryLabel.text = self.searchResult.categories;
    [self.resultImage setImageWithURL:self.searchResult.imageUrl];
    [self.resultRatingImage setImageWithURL:self.searchResult.ratingsUrl];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
