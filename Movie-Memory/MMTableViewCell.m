//
//  MMTableViewCell.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMTableViewCell.h"

@implementation MMTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib {
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
