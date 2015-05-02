//
//  Venue.h
//  FindCoffee
//
//  Created by Amy Wold on 4/25/15.
//  Copyright (c) 2015 Amy Wold. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;

@interface Venue : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Location *location;

@end
