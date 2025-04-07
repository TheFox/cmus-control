
#import <Foundation/Foundation.h>
#import "CCApplication.h"

int nsapp_main(int argc, const char* argv[]){
	NSLog(@"nsapp_main");
	@autoreleasepool{
		NSApplication* application = [CCApplication sharedApplication];
		[NSApp run];
	}
	return 0;
}
