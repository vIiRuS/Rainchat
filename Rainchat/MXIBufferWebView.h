//
//  MXIBufferWebView.h
//  Rainchat
//
//  Created by viirus on 08/10/14.
//
//

#import <WebKit/WebKit.h>

@interface MXIBufferWebView : WebView

-(void)appendItemWithContent:(NSString*)content;
-(void)setItems:(NSArray*)items;

@end
