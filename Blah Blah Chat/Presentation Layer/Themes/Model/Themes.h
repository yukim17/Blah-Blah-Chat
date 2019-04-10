//
//  Themes.h
//  Blah Blah Chat
//
//  Created by Екатерина on 03.03.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Themes_h
#define Themes_h

@interface Themes: NSObject {
    UIColor *_theme1, *_theme2, *_theme3;
}

    @property (nonatomic, retain) UIColor *theme1;
    @property (nonatomic, retain) UIColor *theme2;
    @property (nonatomic, retain) UIColor *theme3;

- (instancetype)initWithColorOne: (UIColor *)theme1 ColorTwo: (UIColor *) theme2 colorThree: (UIColor *) theme3;
- (void)dealloc;

@end

#endif /* Themes_h */
