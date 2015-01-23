//
//  QTAddQuoteViewController.h
//  Quoted
//
//  Created by Lea Marolt on 1/21/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Quote.h"

@interface QTAddQuoteViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *quoteTextView;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextField;
@property (weak, nonatomic) IBOutlet UIButton *bookTagBg;
@property (weak, nonatomic) IBOutlet UIButton *convoTagBg;
@property (weak, nonatomic) IBOutlet UIButton *selfTagBg;
@property (weak, nonatomic) IBOutlet UIButton *movieTagBg;
@property (weak, nonatomic) IBOutlet UIButton *musicTagBg;
@property (weak, nonatomic) IBOutlet UIView *quoteBgView;
@property (weak, nonatomic) IBOutlet UIButton *addQuoteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *musicIcon;
@property (weak, nonatomic) IBOutlet UIImageView *movieIcon;
@property (weak, nonatomic) IBOutlet UIImageView *selfIcon;
@property (weak, nonatomic) IBOutlet UIImageView *convoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bookIcon;
@property (weak, nonatomic) IBOutlet UILabel *bookTag;
@property (weak, nonatomic) IBOutlet UILabel *convoTag;
@property (weak, nonatomic) IBOutlet UILabel *selfTag;
@property (weak, nonatomic) IBOutlet UILabel *movieTag;
@property (weak, nonatomic) IBOutlet UILabel *musicTag;

@property (nonatomic, strong) Quote *sentQuote;
@property (nonatomic) BOOL edit;

- (IBAction)tagBook:(id)sender;
- (IBAction)tagConvo:(id)sender;
- (IBAction)tagSelf:(id)sender;
- (IBAction)tagMovie:(id)sender;
- (IBAction)tagMusic:(id)sender;
- (IBAction)addQuote:(id)sender;

@end
