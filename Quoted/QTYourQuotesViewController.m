//
//  QTYourQuotesViewController.m
//  Quoted
//
//  Created by Lea Marolt Sonnenschein on 1/20/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import "QTYourQuotesViewController.h"
#import "QTCardCell.h"
#import "Quote.h"

#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"

#import "QTAddQuoteViewController.h"

@interface QTYourQuotesViewController () {
    NSMutableArray *quotes;
    NSManagedObjectContext *managedObjectContext;
    NSArray *tags;
    NSArray *noQuotesText;
    BOOL homeView;
    BOOL favoritesView;
    BOOL worldView;
    NSUserDefaults *userDefaults;
}

@end

@implementation QTYourQuotesViewController

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        quotes = [[NSMutableArray alloc] initWithCapacity:20];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        managedObjectContext = [appDelegate managedObjectContext];
        tags = @[@"Book", @"Convo", @"Self", @"Movie", @"Music"];
        noQuotesText = @[@"Omg! She said the *funniest* thing last night...",
                         @"Dude. This movie is golden. It's the next \'Mean Girls\' of quotable movies!",
                         @"You know that one that goes like \"Nah-nah, nah-nah, na-na-naaah. I can show you incredible things...\"",
                         @"You know you want to.",
                         @"!$#%$%&^(* merp. I forgot :(",
                         @"Okay. Seriously. You are hi-LAAAAH-rious!",
                         @"Okay, okay, okay!! I know a great joke! I read it just the other day..."];
        homeView = NO;
        favoritesView = NO;
        worldView = NO;
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [quotes removeAllObjects];
    self.noQuotesViewLabel.text = noQuotesText[arc4random()%7];
    
    self.searchBtn.enabled = NO;
    
//    Quote *quote1 = [Quote quoteWithQuote:@"\"The best way to find yourself is to lose yourself in the service of others.\"" andAuthor:@"Mahatma Gandhi"];
//    Quote *quote2 = [Quote quoteWithQuote:@"\"In any moment of decision, the best thing you can do is the right thing, the next best thing is the wrong thing, and the worst thing you can do is nothing.\"" andAuthor:@"Theodore Roosevelt"];
//    Quote *quote3 = [Quote quoteWithQuote:@"\"Do right. Do your best. Treat others as you want to be treated.\"" andAuthor:@"Lou Holtz"];
//    Quote *quote4 = [Quote quoteWithQuote:@"\"The best way to find yourself is to lose yourself in the service of others.\"" andAuthor:@"Mahatma Gandhi"];
//    Quote *quote5 = [Quote quoteWithQuote:@"\"In any moment of decision, the best thing you can do is the right thing, the next best thing is the wrong thing, and the worst thing you can do is nothing.\"" andAuthor:@"Theodore Roosevelt"];
//    Quote *quote6 = [Quote quoteWithQuote:@"\"Do right. Do your best. Treat others as you want to be treated.\"" andAuthor:@"Lou Holtz"];
//    
//    [quotes addObject:quote1];
//    [quotes addObject:quote2];
//    [quotes addObject:quote3];
//    [quotes addObject:quote4];
//    [quotes addObject:quote5];
//    [quotes addObject:quote6];
    
//    [self addQuoteEntityWithQuote:@"\"Do right. Do your best. Treat others as you want to be treated.\"" andAuthor:@"Lou Holtz"];
//    [self addQuoteEntityWithQuote:@"\"In any moment of decision, the best thing you can do is the right thing, the next best thing is the wrong thing, and the worst thing you can do is nothing.\"" andAuthor:@"Theodore Roosevelt"];
//    [self addQuoteEntityWithQuote:@"\"The best way to find yourself is to lose yourself in the service of others.\"" andAuthor:@"Mahatma Gandhi"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gimmeData) name:@"gimmeData" object:nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Quote"];
    NSError *error;
    NSArray *fetchedResults = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedResults == nil) {
        NSLog(@"Error: %@", error);
        self.noQuotesView.hidden = NO;
        self.searchBg.hidden = YES;
        self.searchBtn.hidden = YES;
    }
    else {
        
        if ([fetchedResults count] == 0) {
            self.noQuotesView.hidden = NO;
            self.searchBg.hidden = YES;
            self.searchBtn.hidden = YES;
        }
        else {
            self.noQuotesView.hidden = YES;
            self.searchBg.hidden = NO;
            self.searchBtn.hidden = NO;
        }
        [quotes addObjectsFromArray:fetchedResults];
    }

    for (Quote *qt in quotes) {
        NSLog(@"Quote: %@", qt.quote);
    }
    
    self.searchResults = [NSMutableArray arrayWithCapacity:20];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:NSLocalizedString(@"All", @"Search display controller All button.")];
    
    [scopeButtonTitles addObject:@"Book"];
    [scopeButtonTitles addObject:@"Convo"];
    [scopeButtonTitles addObject:@"Self"];
    [scopeButtonTitles addObject:@"Movie"];
    [scopeButtonTitles addObject:@"Music"];
    
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar setBackgroundColor:[UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9]];
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
    
    [self.searchController.searchBar setPlaceholder:@"Search quotes and authors."];
    [self.searchController.searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIColor whiteColor], NSBackgroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [self.searchController.searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.definesPresentationContext = YES;
    
    homeView = [userDefaults boolForKey:@"HomeView"];
    favoritesView = [userDefaults boolForKey:@"FavoritesView"];
    worldView = [userDefaults boolForKey:@"WorldView"];
    
    if (homeView) {
        self.userViewBg.backgroundColor = [UIColor whiteColor];
    }
    else if (favoritesView) {
        self.favoritesViewBg.backgroundColor = [UIColor whiteColor];
    }
    else if (worldView) {
        self.worldViewBg.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.userViewBg.backgroundColor = [UIColor whiteColor];
    }
    
    self.heartBtn.enabled = NO;
    self.worldBtn.enabled = NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [userDefaults setBool:YES forKey:@"HomeView"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (worldView || favoritesView) {
        return [self.searchResults count];
    }
    else {
        return [quotes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Card";
    
    QTCardCell *cell = (QTCardCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Quote *quote;
    
    if ((worldView || favoritesView) && [self.searchResults count] > 0) {
        quote = self.searchResults[indexPath.row];
        cell.likesBtn.enabled = NO;
        cell.worldBtn.enabled = NO;
    }
    else  if (homeView) {
        worldView = NO;
        favoritesView = NO;
        homeView = YES;
        quote = quotes[indexPath.row];
    }
    
    // set favorites
    if (quote.isFavorite) {
        cell.likesIcon.image = [UIImage imageNamed:@"HeartDark"];
    }
    else {
        cell.likesIcon.image = [UIImage imageNamed:@"Heart"];
    }
    
    // set broadcast
    if (quote.isBroadcasted) {
        cell.broadcastIcon.image = [UIImage imageNamed:@"WorldDark"];
    }
    else {
        cell.broadcastIcon.image = [UIImage imageNamed:@"World"];
    }
    
    cell.cardBackground.backgroundColor = [self randomColor];
    
    cell.cardQuote.text = quote.quote;
    cell.cardLikes.text = [NSString stringWithFormat:@"%@ likes", quote.likes];
    cell.cardAuthor.text = [NSString stringWithFormat:@"- %@", quote.author];
    if (![quote.tag isEqualToString:@""]) {
        [self tagImage:quote.tag forCell:cell];
    }
    
    NSString *text = quote.quote;
    UIFont *font = [UIFont fontWithName:@"AvenirNext-Regular" size:23.f];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    
    int numOfLines = (int)size.width / (int)tableView.contentSize.width;
    if (numOfLines > 3 && numOfLines < 5) {
        font = [UIFont fontWithName:@"AvenirNext-Regular" size:17.f];
    }
    else if (numOfLines >= 5 && numOfLines <8) {
        font = [UIFont fontWithName:@"AvenirNext-Regular" size:12.f];
    }
    
    [cell.cardQuote setFont:font];
    
    return cell;
}

- (UIColor *) randomColor {
    int hue = arc4random_uniform(361);
    int saturation = 250;
    int brightness = 180;
    
    UIColor *randomColor = [UIColor colorWithHue:hue/360.0 saturation:saturation/360.0 brightness:brightness/360.0 alpha:1];
    
    return randomColor;
}

- (IBAction)addQuote:(id)sender {
}

- (IBAction)userView:(id)sender {
    
    if (!homeView) {
        homeView = YES;
        self.userViewBg.backgroundColor = [UIColor whiteColor];
        [userDefaults setBool:YES forKey:@"HomeView"];
        
        favoritesView = NO;
        self.favoritesViewBg.backgroundColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
        [userDefaults setBool:NO forKey:@"FavoritesView"];
        
        worldView = NO;
        self.worldViewBg.backgroundColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
        [userDefaults setBool:NO forKey:@"WorldView"];
    }
    
    [self updateFilteredContentForQuoteName:nil type:@"HomeView"];
    
    [self.theTableView reloadData];
}

- (IBAction)worldView:(id)sender {
    
    if (!worldView) {
        worldView = YES;
        self.worldViewBg.backgroundColor = [UIColor whiteColor];
        [userDefaults setBool:YES forKey:@"WorldView"];
        
        homeView = NO;
        self.userViewBg.backgroundColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
        [userDefaults setBool:NO forKey:@"HomeView"];
        
        favoritesView = NO;
        self.favoritesViewBg.backgroundColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
        [userDefaults setBool:NO forKey:@"FavoritesView"];
        
    }
    
    [self updateFilteredContentForQuoteName:nil type:@"WorldView"];
    
    [self.theTableView reloadData];
}

- (IBAction)favoritesView:(id)sender {
    
    if (!favoritesView) {
        favoritesView = YES;
        self.favoritesViewBg.backgroundColor = [UIColor whiteColor];
        [userDefaults setBool:YES forKey:@"FavoritesView"];
        
        homeView = NO;
        self.userViewBg.backgroundColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
        [userDefaults setBool:NO forKey:@"HomeView"];
        
        worldView = NO;
        self.worldViewBg.backgroundColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
        [userDefaults setBool:NO forKey:@"WorldView"];
    }
    
    [self updateFilteredContentForQuoteName:nil type:@"FavoritesView"];
    
    [self.theTableView reloadData];
    
}

- (IBAction)toggleFavorites:(id)sender {
    UIButton *btn = (UIButton *)sender;
    QTCardCell *cell = [self parentCellForView:btn];
    NSIndexPath *indexPath = [self.theTableView indexPathForCell:cell];
    
    Quote *quote = quotes[indexPath.row];
        
    if (worldView) {
        int likes = [quote.likes intValue];
    
        likes = likes + 1;
    
        [quote setLikes:[NSNumber numberWithInt:likes]];
    
        cell.cardLikes.text = [NSString stringWithFormat:@"%@ likes", quote.likes];
    }
    else if (homeView) {
        if (![quote.isFavorite boolValue]) {
            quote.isBroadcasted = [NSNumber numberWithBool:YES];
            cell.likesIcon.image = [UIImage imageNamed:@"HeartDark"];
            
            int likes = [quote.likes intValue];
            
            likes = likes + 1;
            
            [quote setLikes:[NSNumber numberWithInt:likes]];
            
            cell.cardLikes.text = [NSString stringWithFormat:@"%@ likes", quote.likes];
            
            quote.isFavorite = [NSNumber numberWithBool:YES];
        }
        else {
            quote.isFavorite  = [NSNumber numberWithBool:NO];
            cell.likesIcon.image = [UIImage imageNamed:@"Heart"];
            
            int likes = [quote.likes intValue];
            
            likes = likes - 1;
            
            [quote setLikes:[NSNumber numberWithInt:likes]];
            
            cell.cardLikes.text = [NSString stringWithFormat:@"%@ likes", quote.likes];
            
            quote.isFavorite = [NSNumber numberWithBool:NO];
        }
        
    }
    
    NSError *error;
    
    if (![quote.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else {
        NSLog(@"Saving!");
    }
    
}

- (IBAction)deleteQuote:(id)sender {
    UIButton *btn = (UIButton *)sender;
    QTCardCell *cell = [self parentCellForView:btn];
    NSIndexPath *indexPath = [self.theTableView indexPathForCell:cell];
    
    Quote *quote = quotes[indexPath.row];
    
    [managedObjectContext deleteObject:quote];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error deleting movie, %@", [error userInfo]);
    }
    else {
        NSLog(@"Succseful save!");
    }

    [quotes removeObject:quote];
    
    [self.theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationMiddle];
    
    if ([quotes count] == 0 || [self.searchResults count] == 0) {
        
        CATransition* transition = [CATransition animation];
        transition.startProgress = 0;
        transition.endProgress = 1.0;
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFade;
        transition.duration = 1.0;
        
        // Add the transition animation to both layers
        [self.noQuotesView.layer addAnimation:transition forKey:@"transition"];
        
        self.noQuotesView.hidden = NO;
        self.searchBg.hidden = YES;
        self.searchBtn.hidden = YES;
    }
}

- (IBAction)searchQuotes:(id)sender {
    
    self.theTableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 100.0);
}

- (IBAction)broadcast:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    QTCardCell *cell = [self parentCellForView:btn];
    NSIndexPath *indexPath = [self.theTableView indexPathForCell:cell];
    
    Quote *quote = quotes[indexPath.row];
    
    
    if (![quote.isBroadcasted boolValue]) {
        quote.isBroadcasted = [NSNumber numberWithBool:YES];
        cell.broadcastIcon.image = [UIImage imageNamed:@"WorldDark"];
    }
    else {
        quote.isBroadcasted = [NSNumber numberWithBool:NO];
        cell.broadcastIcon.image = [UIImage imageNamed:@"World"];
    }
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error deleting movie, %@", [error userInfo]);
    }
    
    else {
        NSLog(@"Successful save!");
    }
    
}

-(QTCardCell *)parentCellForView:(id)theView
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
            if ([viewSuperView isKindOfClass:[QTCardCell class]]) {
                        return (QTCardCell *)viewSuperView;
            }
            else {
                    viewSuperView = [viewSuperView superview];
            }
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // setup the segue
    MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
    MZFormSheetController *formSheet = formSheetSegue.formSheetController;
    formSheet.transitionStyle = MZFormSheetTransitionStyleFade;
    formSheet.cornerRadius = 0;
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        
    };
    
    
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    
    formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
    };
    
    if ([segue.identifier isEqualToString:@"AddQuote"] || [segue.identifier isEqualToString:@"AddFirst"]) {
        formSheet.presentedFormSheetSize = CGSizeMake(350, 520);
        
        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            // Passing data
            QTAddQuoteViewController *aqvc = (QTAddQuoteViewController *)presentedFSViewController;
 
        };
    }
    
    else if ([segue.identifier isEqualToString:@"EditQuote"] || [segue.identifier isEqualToString:@"EditTag"] || [segue.identifier isEqualToString:@"SeeQuote"]) {
        formSheet.presentedFormSheetSize = CGSizeMake(350, 520);
        formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            // Passing data
            QTAddQuoteViewController *aqvc = (QTAddQuoteViewController *)presentedFSViewController;
            NSIndexPath *indexPath = [self.theTableView indexPathForSelectedRow];
            aqvc.sentQuote = quotes[indexPath.row];
            aqvc.edit = YES;
        };
    }
}

- (void)addQuoteEntityWithQuote: (NSString *)quote andAuthor: (NSString *)author andNote: (NSString *)note {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quote" inManagedObjectContext:managedObjectContext];
    
    NSManagedObject *aQuote = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    
    [aQuote setValue:quote forKey:@"quote"];
    [aQuote setValue:author forKey:@"author"];
    [aQuote setValue:note forKey:@"note"];
    [aQuote setValue:[NSNumber numberWithInt:0] forKey:@"likes"];
    
    NSError *error;
    
    if (![aQuote.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    else {
        NSLog(@"Saving!");
        [quotes addObject:aQuote];
    }
}

- (void) gimmeData {
    
    [self someStuff];
}

- (void) someStuff {
    [self viewDidLoad];
    [self.theTableView reloadData];
}

- (void) tagImage: (NSString*)tag forCell: (QTCardCell *)cell {
    
    CGFloat width;
    CGFloat height;
    
    if ([tag isEqualToString:@"Book"]) {
        [cell.tagImage setImage:[UIImage imageNamed:@"Book"]];
        width = 21/1.3;
        height = 32/1.3;
    }
    else if ([tag isEqualToString:@"Convo"]) {
        [cell.tagImage setImage:[UIImage imageNamed:@"Convo"]];
        width = 32/1.3;
        height = 31/1.3;
    }
    else if ([tag isEqualToString:@"Self"]) {
        [cell.tagImage setImage:[UIImage imageNamed:@"Self"]];
        width = 23/1.3;
        height = 32/1.3;
    }
    else if ([tag isEqualToString:@"Movie"]) {
        [cell.tagImage setImage:[UIImage imageNamed:@"Movie"]];
        width = 28/1.3;
        height = 26/1.3;
    }
    else if ([tag isEqualToString:@"Music"]) {
        [cell.tagImage setImage:[UIImage imageNamed:@"Music"]];
        width = 21/1.3;
        height = 31/1.3;
    }
    
    CGRect frame = CGRectMake((self.view.bounds.size.width - width)/2, cell.tagImage.frame.origin.y, width, height);
    
    cell.tagImage.frame = frame;
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSString *scope = nil;
    
    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
    
    if (selectedScopeButtonIndex > 0) {
        scope = [tags objectAtIndex:(selectedScopeButtonIndex - 1)];
    }
    
    [self updateFilteredContentForQuoteName:searchString type:scope];
    
    [self.theTableView reloadData];
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateFilteredContentForQuoteName:(NSString *)quoteName type:(NSString *)filter {
    
    NSString *getView;
    if (worldView) {
        getView = @"WorldView";
    }
    else if (favoritesView) {
        getView = @"FavoritesView";
    }
    else {
        getView = @"HomeView";
    }
    
    NSLog(@"GET VIEW = %@", getView);
    
    // Update the filtered array based on the search text and scope.
    if ((quoteName == nil) || [quoteName length] == 0) {
            // If there is no search string and the scope is "All".
            if (filter == nil) {
                    self.searchResults = [quotes mutableCopy];
                } else {
                        // If there is no search string and the scope is chosen.
                    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
                    for (Quote *qt in quotes) {
                        if ([getView isEqualToString:@"WorldView"]) {
                            if (qt.isBroadcasted) {
                                [searchResults addObject:qt];
                            }
                        }
                        else if ([getView isEqualToString:@"FavoritesView"]){
                            if (qt.isFavorite) {
                                [searchResults addObject:qt];
                            }
                        }
                        else if ([getView isEqualToString:@"HomeView"]){
                            [searchResults addObject:qt];
                        }
                    }
                    self.searchResults = searchResults;
                    NSLog(@"SEARCH RESULTS: %lu", (unsigned long)[searchResults count]);
                }
        return;
    }
    
    
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
              */
    for (Quote *qt in quotes) {
        if ((filter == nil) || [getView isEqualToString:filter]) {
            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
            NSRange quoteNameRange = NSMakeRange(0, qt.author.length);
            NSRange foundRange = [qt.author rangeOfString:quoteName options:searchOptions range:quoteNameRange];
            if (foundRange.length > 0) {
                [self.searchResults addObject:qt];
            }
        }
    }
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
