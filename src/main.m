
#import "main.h"

int main(int argc, const char *argv[]){
	ALog(@"%s %d.%d.%d%s [%d]", PROJECT_NAME, PROJECT_VERSION_MAJOR, PROJECT_VERSION_MINOR, PROJECT_VERSION_PATCH, PROJECT_VERSION_APPENDIX, PROJECT_RELEASE_ID);
	ALog(@"%s", PROJECT_COPYRIGHT);
	
	int rv = 0;
	
	@autoreleasepool{
		
#ifdef PROJECT_USE_PID_FILE
		NSString* processName = [[NSProcessInfo processInfo] processName];
		DLog(@"name: '%@'", processName);
		
		NSMutableString* pidFilePath = [[NSMutableString alloc] initWithString:@"/var/run/"];
		[pidFilePath appendFormat:@"%@.pid", processName];
		
		NSFileManager *filemgr = [NSFileManager defaultManager];
		if([filemgr isWritableFileAtPath:pidFilePath]){
			NSFileHandle *pidFileH = [NSFileHandle fileHandleForWritingAtPath:pidFilePath];
			if(pidFileH){
				
				[pidFileH closeFile];
			}
		}
		else{
			DLog(@"WARNING: Can't write in /var/run");
		}
#endif
		
		// CCAppDelegate* delegate = [CCAppDelegate new];
		NSApplication* application = [CCApplication sharedApplication];
		// [application setDelegate:delegate];
		[NSApp run];
	}
	
	DLog(@"end");
	return rv;
}
