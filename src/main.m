
#import "main.h"

int main(int argc, const char *argv[]){
	ALog(@"%s %d.%d.%d%s (Release %d)", PROJECT_NAME, PROJECT_VERSION_MAJOR, PROJECT_VERSION_MINOR, PROJECT_VERSION_PATCH, PROJECT_VERSION_APPENDIX, PROJECT_RELEASE_ID);
	ALog(@"%s", PROJECT_COPYRIGHT);
	
	int rv = 0;
	
	@autoreleasepool{
		
#ifdef PROJECT_USE_PID_FILE
		NSProcessInfo* pInfo = [NSProcessInfo processInfo];
		NSString* processName = [pInfo processName];
		int processId = [pInfo processIdentifier];
		NSString* processIdStr = [[NSString alloc] initWithFormat:@"%d", processId];
		
		NSString* pidFileDir = @"/var/run";
		NSString* pidFilePath = [[pidFileDir stringByAppendingPathComponent:processName]
			stringByAppendingPathExtension:@"pid"];
		DLog(@"use pid file: %@", pidFilePath);
		
		NSFileManager* filemgr = [NSFileManager defaultManager];
		if([filemgr isWritableFileAtPath:pidFileDir]){
			NSError* error = nil;
			[processIdStr writeToFile:pidFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
		}
		else{
			DLog(@"WARNING: Can't write in %@", pidFileDir);
		}
#else
		DLog(@"no pid file");
#endif
		
		// CCAppDelegate* delegate = [CCAppDelegate new];
		NSApplication* application = [CCApplication sharedApplication];
		// [application setDelegate:delegate];
		[NSApp run];
	}
	
	DLog(@"end");
	return rv;
}
