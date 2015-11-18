
#import "main.h"

CFMachPortRef eventPort;

CGEventRef tapEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon){
	// DLog(@"tapEventCallback");
	
	if(type == kCGEventTapDisabledByTimeout){
		// CGEventTapEnable([[AppleMediaKeyController sharedController] eventPort], TRUE);
		CGEventTapEnable(eventPort, YES);
	}
	
	// DLog(@"tapEventCallback type = %d", type);
	if(type != NX_SYSDEFINED){ return event; }
	
	NSEvent *nsEvent = [NSEvent eventWithCGEvent:event];
	
	// DLog(@"tapEventCallback subtype = %d", [nsEvent subtype]);
	if([nsEvent subtype] != 8){ return event; }
	
	int data = [nsEvent data1];
	int keyCode = (data & 0xFFFF0000) >> 16;
	int keyFlags = (data & 0xFFFF);
	int keyState = (keyFlags & 0xFF00) >> 8;
	BOOL keyIsRepeat = (keyFlags & 0x1) > 0;
	
	// if(keyIsRepeat){ return event; }
	
	// if(keyState == 0xB){
		DLog(@"tapEventCallback keyCode = %d %d %d", keyCode, keyState, keyIsRepeat);
		
		// NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		switch(keyCode){
			case NX_KEYTYPE_PLAY:
				/*if(keyState == NX_KEYSTATE_DOWN)
					[center postNotificationName:MediaKeyPlayPauseNotification object:(AppleMediaKeyController *)refcon];
				if(keyState == NX_KEYSTATE_UP || keyState == NX_KEYSTATE_DOWN)
					return NULL;*/
				DLog(@"tap NX_KEYTYPE_PLAY");
				break;
			
			case NX_KEYTYPE_FAST:
				/*if(keyState == NX_KEYSTATE_DOWN)
					[center postNotificationName:MediaKeyNextNotification object:(AppleMediaKeyController *)refcon];
				if(keyState == NX_KEYSTATE_UP || keyState == NX_KEYSTATE_DOWN)
					return NULL;*/
				DLog(@"tap NX_KEYTYPE_FAST");
				break;
			
			case NX_KEYTYPE_REWIND:
				/*if(keyState == NX_KEYSTATE_DOWN)
					[center postNotificationName:MediaKeyPreviousNotification object:(AppleMediaKeyController *)refcon];
				if(keyState == NX_KEYSTATE_UP || keyState == NX_KEYSTATE_DOWN)
					return NULL;*/
				DLog(@"tap NX_KEYTYPE_REWIND");
				break;
		}
	// }
	
	return event;
}

int main(int argc, const char *argv[]){
	DLog(@"start");
	
	int rv = 0;
	
	@autoreleasepool{
		CKAppDelegate *delegate = [CKAppDelegate new];
		NSApplication *application = [CKApplication sharedApplication];
		[application setDelegate:delegate];
		
		/*
		eventPort = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault,
				CGEventMaskBit(NX_SYSDEFINED), tapEventCallback, nil);
		if(eventPort == NULL){
			ALog(@"FATAL ERROR: Event Tap could not be created");
			rv = 1;
		}
		else{
			CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorSystemDefault, eventPort, 0);
			if(runLoopSource == NULL){
				ALog(@"FATAL ERROR: Run Loop Source could not be created");
				rv = 2;
			}
			else{
				CFRunLoopRef runLoop = CFRunLoopGetCurrent();
				if(runLoop == NULL){
					ALog(@"FATAL ERROR: Couldn't get current threads Run Loop");
					rv = 3;
				}
				else{
					CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopCommonModes);
					// DLog(@"loop run"); CFRunLoopRun();
				}
				DLog(@"release runLoopSource");
				CFRelease(runLoopSource);
			}
			DLog(@"release eventPort");
			CFRelease(eventPort);
		}
		*/
		
		[NSApp run];
	}
	
	DLog(@"end");
	return rv;
}
