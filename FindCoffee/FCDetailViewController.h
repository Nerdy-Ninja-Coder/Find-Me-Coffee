//
//  FCDetailViewController.h
//  FindCoffee
//
//  Created by Amy Wold on 4/24/15.
//  Copyright (c) 2015 Amy Wold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) NSNumber *detailLat;
@property (strong, nonatomic) NSNumber *detailLong;

@end

