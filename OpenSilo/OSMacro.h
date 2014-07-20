#define IS_IPAD() (UI_USER_INTER®FACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
#define IS_SIMULATOR ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound)

#define appDelegateMacro ((TiesAppDelegate *)[[UIApplication sharedApplication] delegate])

#ifdef __IPHONE_6_0
#define ALIGN_LEFT NSTextAlignmentLeft
#else
#define ALIGN_LEFT UITextAlignmentLeft
#endif

#ifdef __IPHONE_6_0
#define ALIGN_CENTER NSTextAlignmentCenter
#else
#define ALIGN_CENTER UITextAlignmentCenter
#endif

#ifdef __IPHONE_6_0
#define ALIGN_RIGHT NSTextAlignmentRight
#else
#define ALIGN_RIGHT UITextAlignmentRight
#endif

#ifdef __IPHONE_6_0
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
#else
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
#endif

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
