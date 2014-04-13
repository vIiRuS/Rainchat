//
// Created by Maximilian Gaß on 13.04.14.
// Copyright (c) 2014 Maximilian Gaß. All rights reserved.
//

#import "MXIClientBufferNotice.h"


@implementation MXIClientBufferNotice {

}
- (NSMutableDictionary *)stringAttributes {
    NSMutableDictionary *stringAttributes = [super stringAttributes];

    NSFont *normalFont = stringAttributes[NSFontAttributeName];
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSFont *italicFont = [fontManager fontWithFamily:normalFont.familyName
                                              traits:NSItalicFontMask
                                              weight:0
                                                size:normalFont.pointSize];

    stringAttributes[NSFontAttributeName] = italicFont;
    return stringAttributes;
}

@end
