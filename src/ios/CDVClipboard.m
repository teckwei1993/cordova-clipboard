#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "CDVClipboard.h"

@implementation CDVClipboard

- (void)copy:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		NSString     *text       = [command.arguments objectAtIndex:0];

		pasteboard.string = text;

		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)paste:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		NSString     *text       = [pasteboard valueForPasteboardType:@"public.text"];
		if (text == nil) {
			text = @"";
		}

		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)clear:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    		[pasteboard setValue:@"" forPasteboardType:UIPasteboardNameGeneral];

		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)detectTaobaoLink:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		if (@available(iOS 15.0, *)) {
	        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	        [pasteboard detectPatternsForPatterns:[NSSet setWithObjects:UIPasteboardDetectionPatternLink, UIPasteboardDetectionPatternFlightNumber, nil]
	                            completionHandler:^(NSSet<UIPasteboardDetectionPattern> * _Nullable set, NSError * _Nullable error) {
	            BOOL hasLink = NO, hasFlightNumber = NO, isTaoBao = NO;
	            for (NSString *type in set) {
	                if ([type isEqualToString:UIPasteboardDetectionPatternLink]) {
	                    hasLink = YES;
	                } else if ([type isEqualToString:UIPasteboardDetectionPatternFlightNumber]) {
	                    hasFlightNumber = YES;
	                }
	            }

	            if (hasLink && hasFlightNumber) {
                    isTaoBao = YES;
	            }

	            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isTaoBao];
				[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	        }];
	    }else{
	        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	    }
	}];
}

@end
