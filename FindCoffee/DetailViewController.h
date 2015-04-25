//
//  DetailViewController.h
//  FindCoffee
//
//  Created by Amy Wold on 4/24/15.
//  Copyright (c) 2015 Amy Wold. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

