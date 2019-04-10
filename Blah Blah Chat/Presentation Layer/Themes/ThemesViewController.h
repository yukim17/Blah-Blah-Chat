//
//  ThemesViewController.h
//  Blah Blah Chat
//
//  Created by Екатерина on 03.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Model/Themes.h"
#import "ThemesViewControllerDelegate.h"

#ifndef ThemesViewController_h
#define ThemesViewController_h
@interface ThemesViewController: UIViewController {
    
    Themes *_model;
    id<ThemesViewControllerDelegate> _delegate;
}

@property (nonatomic, retain)Themes *model;
@property (nonatomic, assign) id<ThemesViewControllerDelegate> delegate;

    - (IBAction)selectTheme1:(id)sender;
    - (IBAction)selectTheme2:(id)sender;
    - (IBAction)selectTheme3:(id)sender;
    - (IBAction)closeSettings:(id)sender;


@end


#endif /* ThemesViewController_h */
