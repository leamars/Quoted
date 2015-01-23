//
//  QTCardCell.m
//  Quoted
//
//  Created by Lea Marolt Sonnenschein on 1/20/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "QTCardCell.h"

@implementation QTCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


@end
