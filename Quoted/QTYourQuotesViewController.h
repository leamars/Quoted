//
//  QTYourQuotesViewController.h
//  Quoted
//
//  Created by Lea Marolt Sonnenschein on 1/20/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Quote.h"

@interface QTYourQuotesViewController : UIViewController <UITabBarControllerDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (weak, nonatomic) IBOutlet UIView *noQuotesView;
@property (weak, nonatomic) IBOutlet UIView *searchBg;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;
@property (weak, nonatomic) IBOutlet UILabel *noQuotesViewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *broadcastIcon;

- (IBAction)addQuote:(id)sender;
- (IBAction)userView:(id)sender;
- (IBAction)worldView:(id)sender;
- (IBAction)favoritesView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *userViewBg;
@property (weak, nonatomic) IBOutlet UIView *worldViewBg;
@property (weak, nonatomic) IBOutlet UIView *favoritesViewBg;

- (IBAction)toggleFavorites:(id)sender;
- (IBAction)deleteQuote:(id)sender;
- (IBAction)searchQuotes:(id)sender;

- (IBAction)broadcast:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *worldBtn;

@property (weak, nonatomic) IBOutlet UIButton *heartBtn;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end
