//
//  QTAddQuoteViewController.m
//  Quoted
//
//  Created by Lea Marolt on 1/21/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//


#import "QTAddQuoteViewController.h"
#import "MZFormSheetController.h"
#import "Quote.h"
#import "QTYourQuotesViewController.h"

@interface QTAddQuoteViewController () {
    NSString *newQuote;
    NSString *newAuthor;
    NSString *newNote;
    NSString *newTag;
    
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *quotes;
    CGRect originalFrame;
    
    BOOL BOOK;
    BOOL MOVIE;
    BOOL MUSIC;
    BOOL SELF;
    BOOL CONVO;
}

@end

@implementation QTAddQuoteViewController


-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        managedObjectContext = [appDelegate managedObjectContext];
        
        BOOK = NO;
        MOVIE = NO;
        MUSIC = NO;
        SELF = NO;
        CONVO = NO;
}
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [quotes removeAllObjects];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Quote"];
    NSError *error;
    NSArray *fetchedResults = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedResults == nil) {
        NSLog(@"Error: %@", error);
    }
    else {
        [quotes addObjectsFromArray:fetchedResults];
        for (Quote *aQuote in quotes) {
            //NSLog(@"Quote: %@", aQuote.quote);
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.sentQuote) {
    
        self.authorTextField.text = self.sentQuote.author;
        self.noteTextField.text = self.sentQuote.note;
        self.quoteTextView.text = self.sentQuote.quote;
        [self markTag:self.sentQuote.tag];
        
        self.addQuoteBtn.titleLabel.text = @"Save Quote";
    }
    else {
        self.addQuoteBtn.titleLabel.text = @"Add Quote";
    }
    
    if (self.edit) {
        
    }
    else {
        [self.quoteTextView becomeFirstResponder];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancel:(id)sender {
    MZFormSheetController *controller = self.formSheetController;
    [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}


- (IBAction)tagBook:(id)sender {
    
    if (BOOK == NO) {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.bookIcon withImage:[UIImage imageNamed:@"BookDark"]     andTagLabel:self.bookTag andTagImageBackground:self.bookTagBg forSelected:NO];
        BOOK = YES;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.convoIcon withImage:[UIImage imageNamed:@"Convo"]     andTagLabel:self.convoTag andTagImageBackground:self.convoTagBg forSelected:YES];
        CONVO = NO;
        
        [self animationForTagImage:self.selfIcon withImage:[UIImage imageNamed:@"Self"]     andTagLabel:self.selfTag andTagImageBackground:self.selfTagBg forSelected:YES];
        SELF = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.movieIcon withImage:[UIImage imageNamed:@"Movie"]     andTagLabel:self.movieTag andTagImageBackground:self.movieTagBg forSelected:YES];
        MOVIE = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.musicIcon withImage:[UIImage imageNamed:@"Music"]     andTagLabel:self.musicTag andTagImageBackground:self.musicTagBg forSelected:YES];
        MUSIC = NO;
    }
    else {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.bookIcon withImage:[UIImage imageNamed:@"Book"]     andTagLabel:self.bookTag andTagImageBackground:self.bookTagBg forSelected:YES];
        BOOK = NO;
    }
    
    if (![self isFirstResponder]) {
        for (UIView *subView in self.view.subviews) {
            if ([subView isFirstResponder]) {
                [subView resignFirstResponder];
            }
        }
    }
    
    // if we are deselecting it as the tag for the quote
    
}
- (IBAction)tagConvo:(id)sender {
    if (CONVO == NO) {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.convoIcon withImage:[UIImage imageNamed:@"ConvoDark"]     andTagLabel:self.convoTag andTagImageBackground:self.convoTagBg forSelected:NO];
        CONVO = YES;
        
        [self animationForTagImage:self.bookIcon withImage:[UIImage imageNamed:@"Book"]     andTagLabel:self.bookTag andTagImageBackground:self.bookTagBg forSelected:YES];
        BOOK = NO;
        
        [self animationForTagImage:self.selfIcon withImage:[UIImage imageNamed:@"Self"]     andTagLabel:self.selfTag andTagImageBackground:self.selfTagBg forSelected:YES];
        SELF = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.movieIcon withImage:[UIImage imageNamed:@"Movie"]     andTagLabel:self.movieTag andTagImageBackground:self.movieTagBg forSelected:YES];
        MOVIE = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.musicIcon withImage:[UIImage imageNamed:@"Music"]     andTagLabel:self.musicTag andTagImageBackground:self.musicTagBg forSelected:YES];
        MUSIC = NO;
    }
    else {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.convoIcon withImage:[UIImage imageNamed:@"Convo"]     andTagLabel:self.convoTag andTagImageBackground:self.convoTagBg forSelected:YES];
        CONVO = NO;
    }
    
    if (![self isFirstResponder]) {
        for (UIView *subView in self.view.subviews) {
            if ([subView isFirstResponder]) {
                [subView resignFirstResponder];
            }
        }
    }
}
- (IBAction)tagSelf:(id)sender {
    if (SELF == NO) {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.selfIcon withImage:[UIImage imageNamed:@"SelfDark"]     andTagLabel:self.selfTag andTagImageBackground:self.selfTagBg forSelected:NO];
        SELF = YES;
        
        [self animationForTagImage:self.bookIcon withImage:[UIImage imageNamed:@"Book"]     andTagLabel:self.bookTag andTagImageBackground:self.bookTagBg forSelected:YES];
        BOOK = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.convoIcon withImage:[UIImage imageNamed:@"Convo"]     andTagLabel:self.convoTag andTagImageBackground:self.convoTagBg forSelected:YES];
        CONVO = NO;

        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.movieIcon withImage:[UIImage imageNamed:@"Movie"]     andTagLabel:self.movieTag andTagImageBackground:self.movieTagBg forSelected:YES];
        MOVIE = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.musicIcon withImage:[UIImage imageNamed:@"Music"]     andTagLabel:self.musicTag andTagImageBackground:self.musicTagBg forSelected:YES];
        MUSIC = NO;
    }
    else {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.selfIcon withImage:[UIImage imageNamed:@"Self"]     andTagLabel:self.selfTag andTagImageBackground:self.selfTagBg forSelected:YES];
        SELF = NO;
    }
    
    if (![self isFirstResponder]) {
        for (UIView *subView in self.view.subviews) {
            if ([subView isFirstResponder]) {
                [subView resignFirstResponder];
            }
        }
    }
}
- (IBAction)tagMovie:(id)sender {
    if (MOVIE == NO) {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.movieIcon withImage:[UIImage imageNamed:@"MovieDark"]     andTagLabel:self.movieTag andTagImageBackground:self.movieTagBg forSelected:NO];
        MOVIE = YES;
        
        [self animationForTagImage:self.bookIcon withImage:[UIImage imageNamed:@"Book"]     andTagLabel:self.bookTag andTagImageBackground:self.bookTagBg forSelected:YES];
        BOOK = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.convoIcon withImage:[UIImage imageNamed:@"Convo"]     andTagLabel:self.convoTag andTagImageBackground:self.convoTagBg forSelected:YES];
        CONVO = NO;
        
        [self animationForTagImage:self.selfIcon withImage:[UIImage imageNamed:@"Self"]     andTagLabel:self.selfTag andTagImageBackground:self.selfTagBg forSelected:YES];
        SELF = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.musicIcon withImage:[UIImage imageNamed:@"Music"]     andTagLabel:self.musicTag andTagImageBackground:self.musicTagBg forSelected:YES];
        MUSIC = NO;
    }
    else {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.movieIcon withImage:[UIImage imageNamed:@"Movie"]     andTagLabel:self.movieTag andTagImageBackground:self.movieTagBg forSelected:YES];
        MOVIE = NO;
    }
    
    if (![self isFirstResponder]) {
        for (UIView *subView in self.view.subviews) {
            if ([subView isFirstResponder]) {
                [subView resignFirstResponder];
            }
        }
    }
}
- (IBAction)tagMusic:(id)sender {
    if (MUSIC == NO) {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.musicIcon withImage:[UIImage imageNamed:@"MusicDark"]     andTagLabel:self.musicTag andTagImageBackground:self.musicTagBg forSelected:NO];
        MUSIC = YES;
        
        [self animationForTagImage:self.bookIcon withImage:[UIImage imageNamed:@"Book"]     andTagLabel:self.bookTag andTagImageBackground:self.bookTagBg forSelected:YES];
        BOOK = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.convoIcon withImage:[UIImage imageNamed:@"Convo"]     andTagLabel:self.convoTag andTagImageBackground:self.convoTagBg forSelected:YES];
        CONVO = NO;
        
        [self animationForTagImage:self.selfIcon withImage:[UIImage imageNamed:@"Self"]     andTagLabel:self.selfTag andTagImageBackground:self.selfTagBg forSelected:YES];
        SELF = NO;
        
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.movieIcon withImage:[UIImage imageNamed:@"Movie"]     andTagLabel:self.movieTag andTagImageBackground:self.movieTagBg forSelected:YES];
        MOVIE = NO;
    }
    else {
        // if we are just now selecting it as the tag for the quote
        [self animationForTagImage:self.musicIcon withImage:[UIImage imageNamed:@"Music"]     andTagLabel:self.musicTag andTagImageBackground:self.musicTagBg forSelected:YES];
        MUSIC = NO;
    }
    
    if (![self isFirstResponder]) {
        for (UIView *subView in self.view.subviews) {
            if ([subView isFirstResponder]) {
                [subView resignFirstResponder];
            }
        }
    }
}

- (IBAction)addQuote:(id)sender {
    
    if (self.sentQuote) {
        self.sentQuote.quote = self.quoteTextView.text;
        self.sentQuote.author = self.authorTextField.text;
        self.sentQuote.note = self.noteTextField.text;
        self.sentQuote.tag = [self getTag];
        
        NSError *error;
        
        if (![self.sentQuote.managedObjectContext save:&error]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        else {
            NSLog(@"Saving!");
        }
    }
    else {
        newQuote = self.quoteTextView.text;
        newAuthor = self.authorTextField.text;
        newNote = self.noteTextField.text;
        newTag = [self getTag];
        
        NSLog(@"Right before I save, the tag is: %@", newTag);
        
        [self addQuoteEntityWithQuote:newQuote andAuthor:newAuthor andNote:newNote andTag:newTag];
    }
    
    [self newDataNotification];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //[self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //[self animateTextField:textField up:NO];
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    if ([textView isEqual:self.noteTextField]) {
        [self animateTextField:textView up:YES];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    if ([textView isEqual:self.noteTextField]) {
        //NSLog(@"ENDED EDITING!");
        [self animateTextField:textView up:NO];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@"\n"]) {
        
    }
    else {
        
        newAuthor = textField.text;
        
        //NSLog(@"New Author: %@", newAuthor);
        
        [textField resignFirstResponder];
        
        UIResponder* nextResponder = self.noteTextField;
        [nextResponder becomeFirstResponder];
    }
    return NO;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([textView isEqual:self.quoteTextView]) {
            
            newQuote = textView.text;
            
            //NSLog(@"New Quote: %@", newQuote);
            
            [textView resignFirstResponder];
            UIResponder* nextResponder = self.authorTextField;
            [nextResponder becomeFirstResponder];
        }
        else if ([textView isEqual:self.noteTextField]) {
            // make a new quote
            newNote = textView.text;
            newQuote = self.quoteTextView.text;
            newAuthor = self.authorTextField.text;
            
            //NSLog(@"New Quote: %@", newQuote);
            newTag = [self getTag];
            NSLog(@"Right before I save, the tag is: %@", newTag);
            
            [self addQuoteEntityWithQuote:newQuote andAuthor:newAuthor andNote:newNote andTag:newTag
             ];
            
            [self newDataNotification];
            
            [textView resignFirstResponder];
        }
        return NO;
    }
    else {
        return YES;
    }
}

- (void) animateTextField: (UITextView *)textView up: (BOOL) up
{
    const int movementDistance = 130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : 0);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);

    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //where text field is a @property (nonatomic,retain) IBOutlet to your textfield
    [self.view endEditing:YES];
    
}

- (void)addQuoteEntityWithQuote: (NSString *)quote andAuthor: (NSString *)author andNote: (NSString *)note andTag: (NSString *)tag {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quote" inManagedObjectContext:managedObjectContext];
    
    NSManagedObject *aQuote = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    
    [aQuote setValue:quote forKey:@"quote"];
    [aQuote setValue:author forKey:@"author"];
    [aQuote setValue:note forKey:@"note"];
    [aQuote setValue:tag forKey:@"tag"];
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

- (void) newDataNotification {
    MZFormSheetController *controller = self.formSheetController;
    [controller mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gimmeData" object:nil];
}

- (void) animationForTagImage:(UIImageView *)tagImage withImage:(UIImage *)newImage andTagLabel:(UILabel *)tagLabel andTagImageBackground:(UIView *)tagImageBg forSelected:(BOOL)selection {
    
    CATransition* transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 0.2;
    transition.type = kCATransitionFade;
    transition.duration = 0.2;
    
    // Add the transition animation to both layers
    [tagImageBg.layer addAnimation:transition forKey:@"transition"];
    [tagImage.layer addAnimation:transition forKey:@"transition"];
    [tagLabel.layer addAnimation:transition forKey:@"transition"];
    
    if (!selection) {
    
        tagImageBg.backgroundColor = [UIColor whiteColor];
        [tagImage setImage:newImage];
        tagLabel.textColor = [UIColor colorWithRed:43/255.0 green:46/255.0 blue:48/255.0 alpha:1];
    }
    else {
        tagImageBg.backgroundColor = [UIColor colorWithRed:30/256.0 green:33/256.0 blue:35/256.0 alpha:0.9];
        [tagImage setImage:newImage];
        tagLabel.textColor = [UIColor whiteColor];
    }
}

- (NSString *) getTag {
    
    NSString *tag;
    
    if (BOOK) {
        tag = @"Book";
    }
    else if (CONVO) {
        tag = @"Convo";
    }
    else if (SELF) {
        tag = @"Self";
    }
    else if (MOVIE) {
        tag = @"Movie";
    }
    else if (MUSIC) {
        tag = @"Music";
    }
    else {
        tag = @"";
    }
    
    NSLog(@"WHAT TAG AM I PUTTING: %@", tag);
    
    return tag;
}

- (void) markTag: (NSString *)tag {
    if ([tag isEqualToString:@"Book"]) {
        [self animationForTagImage:self.bookIcon withImage:[UIImage imageNamed:@"BookDark"]     andTagLabel:self.bookTag andTagImageBackground:self.bookTagBg forSelected:NO];
        BOOK = YES;
    }
    else if ([tag isEqualToString:@"Convo"]) {
        [self animationForTagImage:self.convoIcon withImage:[UIImage imageNamed:@"ConvoDark"]     andTagLabel:self.convoTag andTagImageBackground:self.convoTagBg forSelected:NO];
        CONVO = YES;
    }
    else if ([tag isEqualToString:@"Self"]) {
        [self animationForTagImage:self.selfIcon withImage:[UIImage imageNamed:@"SelfDark"]     andTagLabel:self.selfTag andTagImageBackground:self.selfTagBg forSelected:NO];
        SELF = YES;
    }
    else if ([tag isEqualToString:@"Movie"]) {
        [self animationForTagImage:self.movieIcon withImage:[UIImage imageNamed:@"MovieDark"]     andTagLabel:self.movieTag andTagImageBackground:self.movieTagBg forSelected:NO];
        MOVIE = YES;
    }
    else if ([tag isEqualToString:@"Music"]) {
        [self animationForTagImage:self.musicIcon withImage:[UIImage imageNamed:@"MusicDark"]     andTagLabel:self.musicTag andTagImageBackground:self.musicTagBg forSelected:NO];
        MUSIC = YES;
    }
    
}

@end
