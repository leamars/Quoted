//
//  Quote.h
//  
//
//  Created by Lea Marolt on 1/21/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quote : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * quote;
@property (nonatomic, retain) NSString * tag;

@end
