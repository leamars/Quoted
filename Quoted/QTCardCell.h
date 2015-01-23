//
//  QTCardCell.h
//  Quoted
//
//  Created by Lea Marolt Sonnenschein on 1/20/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cardBackground;
@property (weak, nonatomic) IBOutlet UILabel *cardQuote;
@property (weak, nonatomic) IBOutlet UILabel *cardLikes;
@property (weak, nonatomic) IBOutlet UILabel *cardAuthor;
@property (nonatomic) int likes;
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;
@property (weak, nonatomic) IBOutlet UIImageView *broadcastIcon;
@property (weak, nonatomic) IBOutlet UIImageView *likesIcon;
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
@property (weak, nonatomic) IBOutlet UIButton *worldBtn;


@end
