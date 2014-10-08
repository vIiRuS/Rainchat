//
//  MXIBufferWebView.m
//  Rainchat
//
//  Created by viirus on 08/10/14.
//
//

#import "MXIBufferWebView.h"

@implementation MXIBufferWebView

-(void)awakeFromNib{
    [super awakeFromNib];
    [[self mainFrame] loadHTMLString:@"<html><head><style>ul {list-style-type:none;padding:0;margin:0;}</style></head><body><ul id='items'></ul></body></html>" baseURL:nil];
    [self setEditable:YES];
}

- (void) scrollToElement:(DOMHTMLElement*)element {
    NSRect myRect = element.boundingBox;
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(%d,%d);", (int)myRect.origin.x, (int)myRect.origin.y]];
}

- (void)appendItemWithContent:(NSString *)content {
    DOMHTMLElement *itemsNode = (DOMHTMLElement *) [[[self mainFrame] DOMDocument] getElementById:@"items"];
    DOMHTMLElement *newNode = (DOMHTMLElement *) [[[self mainFrame] DOMDocument] createElement:@"li"];
    [newNode setInnerHTML:content];
    [itemsNode appendChild:newNode];
    [self scrollToElement:newNode];
}

-(void)setItems:(NSArray *)items {
    DOMHTMLElement *itemsNode = (DOMHTMLElement *) [[[self mainFrame] DOMDocument] getElementById:@"items"];
    [itemsNode setInnerHTML:@""];
    DOMHTMLElement *newNode;
    for (NSString *item in items) {
        newNode = (DOMHTMLElement *) [[[self mainFrame] DOMDocument] createElement:@"li"];
        [newNode setInnerHTML:item];
        [itemsNode appendChild:newNode];
    }
    [self scrollToElement:newNode];
}

@end
