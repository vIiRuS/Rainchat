//
// Created by Maximilian Gaß on 13.04.14.
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
                                              weight:[fontManager weightOfFont:normalFont]
                                                size:normalFont.pointSize];

    stringAttributes[NSFontAttributeName] = italicFont;
    return stringAttributes;
}

@end
