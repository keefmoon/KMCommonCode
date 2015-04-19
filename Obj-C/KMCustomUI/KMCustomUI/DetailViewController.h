//
//  DetailViewController.h
//  KMCustomUI
//
//  Created by Keith Moon on 30/12/2014.
//  Copyright (c) 2014 Keith Moon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

