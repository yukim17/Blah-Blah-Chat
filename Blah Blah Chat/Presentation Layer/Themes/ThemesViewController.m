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
        [self reloadView];
    }

    - (IBAction)selectTheme2:(id)sender {
        UIColor *themeTwo = [[self model] theme2];
        [self.delegate themesViewController:self didSelectTheme:themeTwo];
        self.view.backgroundColor = themeTwo;
        [self reloadView];
    }

    - (IBAction)selectTheme3:(id)sender {
        UIColor *themeThree = [[self model] theme3];
        [self.delegate themesViewController:self didSelectTheme:themeThree];
        self.view.backgroundColor = themeThree;
        [self reloadView];
    }

    - (IBAction)closeSettings:(id)sender {
        [self dismissViewControllerAnimated:true completion:nil];
    }

-(void)reloadView {
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
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

-(void)setDelegate:(id<ThemesViewControllerDelegate>)delegate {
    _delegate = delegate;
}

-(id<ThemesViewControllerDelegate>)delegate {
    return _delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *light = [[UIColor alloc] initWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0];
    UIColor *dark = [[UIColor alloc] initWithRed:75.0f/255.0f green:75.0f/255.0f blue:75.0f/255.0f alpha:1.0];
    UIColor *lightBlue = [[UIColor alloc] initWithRed:219.0f/255.0f green:234.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    
    Themes *model = [[Themes alloc] initWithColorOne: light ColorTwo: dark colorThree: lightBlue];
    [self setModel:model];
    [model release];
}

- (void)dealloc {
    [_model release];
    [super dealloc];
}

@end
