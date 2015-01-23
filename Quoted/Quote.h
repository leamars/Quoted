//
//  Quote.h
//  Quoted
//
//  Created by Lea Marolt on 1/22/15.
//  Copyright (c) 2015 Hellosunschein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quote : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * quote;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * isBroadcasted;

@end
