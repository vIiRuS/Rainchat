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
}

- (void)appendItemWithContent:(NSString *)content {
    DOMHTMLElement *itemsNode = (DOMHTMLElement *) [[[[self mainFrame] DOMDocument] getElementsByName:@"items"] item:0];
    DOMHTMLElement *newNode = (DOMHTMLElement *) [[[self mainFrame] DOMDocument] createElement:@"li"];
    [newNode setInnerHTML:content];
    [itemsNode appendChild:newNode];
}

-(void)setItems:(NSString *)items {
    DOMHTMLElement *itemsNode = (DOMHTMLElement *) [[[self mainFrame] DOMDocument] getElementById:@"items"];
    [itemsNode setInnerHTML:items];
}

@end
