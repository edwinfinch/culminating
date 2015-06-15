//
//  ViewController.h
//  Culminating
//
//  Created by Edwin Finch on 2015-06-12.
//  Copyright (c) 2015 Edwin Finch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property IBOutlet UIButton *button;
@property IBOutlet UILabel *lastSeenLabel, *temperatureLabel, *lightLabel, *uptimeLabel;
@property IBOutlet UISwitch *leftLEDSwitch, *rightLEDSwitch;

@end

