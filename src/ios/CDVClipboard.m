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

- (void)patterns:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        if (@available(iOS 15.0, *)) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard detectPatternsForPatterns:[NSSet setWithObjects:
                                                       UIPasteboardDetectionPatternLink,
                                                   UIPasteboardDetectionPatternFlightNumber,
                                                   UIPasteboardDetectionPatternNumber,
                                                   UIPasteboardDetectionPatternMoneyAmount,
                                                   UIPasteboardDetectionPatternPhoneNumber,
                                                   UIPasteboardDetectionPatternEmailAddress,
                                                   UIPasteboardDetectionPatternCalendarEvent,
                                                   UIPasteboardDetectionPatternPostalAddress,
                                                   UIPasteboardDetectionPatternProbableWebURL,
                                                   UIPasteboardDetectionPatternProbableWebSearch,
                                                   UIPasteboardDetectionPatternShipmentTrackingNumber,
                                                   nil]
                                completionHandler:^(NSSet<UIPasteboardDetectionPattern> * _Nullable set, NSError * _Nullable error) {
                NSMutableArray *patterns= [[NSMutableArray alloc]init];
                for (NSString *type in set) {
                    if ([type isEqualToString:UIPasteboardDetectionPatternLink]) {
                        [patterns addObject: @"Link"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternFlightNumber]) {
                        [patterns addObject: @"FlightNumber"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternNumber]) {
                        [patterns addObject: @"Number"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternMoneyAmount]) {
                        [patterns addObject: @"MoneyAmount"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternPhoneNumber]) {
                        [patterns addObject: @"PhoneNumber"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternEmailAddress]) {
                        [patterns addObject: @"EmailAddress"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternCalendarEvent]) {
                        [patterns addObject: @"CalendarEvent"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternPostalAddress]) {
                        [patterns addObject: @"PostalAddress"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternProbableWebURL]) {
                        [patterns addObject: @"ProbableWebURL"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternProbableWebSearch]) {
                        [patterns addObject: @"ProbableWebSearch"];
                    } else if ([type isEqualToString:UIPasteboardDetectionPatternShipmentTrackingNumber]) {
                        [patterns addObject: @"ShipmentTrackingNumber"];
                    }
                }

                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:patterns];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];
        }else{
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:false];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

@end
