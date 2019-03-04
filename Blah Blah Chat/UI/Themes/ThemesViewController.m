//
//  ThemesViewController.m
//  Blah Blah Chat
//
//  Created by Екатерина on 03.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemesViewController.h"

@implementation ThemesViewController

    - (IBAction)selectTheme1:(id)sender {
        UIColor *themeOne = [[self model] theme1];
        [self.delegate themesViewController:self didSelectTheme:themeOne];
        self.view.backgroundColor = themeOne;
    }

    - (IBAction)selectTheme2:(id)sender {
        UIColor *themeTwo = [[self model] theme2];
        [self.delegate themesViewController:self didSelectTheme:themeTwo];
        self.view.backgroundColor = themeTwo;
    }

    - (IBAction)selectTheme3:(id)sender {
        UIColor *themeThree = [[self model] theme3];
        [self.delegate themesViewController:self didSelectTheme:themeThree];
        self.view.backgroundColor = themeThree;
    }

    - (IBAction)closeSettings:(id)sender {
        [self dismissViewControllerAnimated:true completion:nil];
    }

- (void)setModel:(Themes *)model {
    if (_model != model) {
        [model retain];
        [_model release];
        _model = model;
    }
}

- (Themes *)model {
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *lightThemeColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    UIColor *darkThemeColor = [[UIColor alloc] initWithRed:75.0f/255.0f green:75.0f/255.0f blue:75.0f/255.0f alpha:1.0];
    UIColor *champagneThemeColor = [[UIColor alloc] initWithRed:197.0f/255.0f green:179.0f/255.0f blue:88.0f/255.0f alpha:1.0];
    
    Themes *model = [[Themes alloc] initWithColorOne: lightThemeColor ColorTwo: darkThemeColor colorThree: champagneThemeColor];
    [self setModel:model];
    [model release];
}

- (void)dealloc {
    [_model release];
    [super dealloc];
}

@end
