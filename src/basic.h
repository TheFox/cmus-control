
#ifndef _BASIC_H
#define _BASIC_H 1

// http://stackoverflow.com/a/969291
#ifdef DEBUG
//#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#	define DLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#	define FLog(fmt, ...) NSLog((@"%s" fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#	define DLog(...)
#	define FLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
//#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define ALog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)

#endif
