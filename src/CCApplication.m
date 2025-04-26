
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <IOKit/hidsystem/ev_keymap.h>

#import "CCApplication.h"

@implementation CCApplication

- (void)sendEvent:(NSEvent*)anEvent{

	if([anEvent type] == NSSystemDefined && [anEvent subtype] == 8){
		int data = [anEvent data1];
		int keyCode = ((data & 0xffff0000) >> 16);
		int keyFlags = (data & 0x0000ffff);
		int keyState = (((keyFlags & 0xff00) >> 8)) == 0xa;
		BOOL keyIsRepeat = (keyFlags & 0x1) > 0;

		if(keyState){
			int cr;
			switch(keyCode){
				case NX_KEYTYPE_PLAY:
					cr = system("cmus-remote -u");
					NSLog(@"%d %d %d %d  Play", keyCode, keyState, keyIsRepeat, cr);
					break;

				case NX_KEYTYPE_FAST:
				case NX_KEYTYPE_NEXT:
					cr = system("cmus-remote -n");
					NSLog(@"%d %d %d %d  Next", keyCode, keyState, keyIsRepeat, cr);
					break;

				case NX_KEYTYPE_REWIND:
				case NX_KEYTYPE_PREVIOUS:
					cr = system("cmus-remote -r");
					NSLog(@"%d %d %d %d  Previous", keyCode, keyState, keyIsRepeat, cr);
					break;
			}
		}
	}

	[super sendEvent:anEvent];
}

@end
