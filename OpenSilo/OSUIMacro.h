#define SHADOW(view) \
CALayer *layer = view.layer;\
layer.bounds = view.bounds;\
layer.shadowColor = [UIColor blackColor].CGColor;\
layer.shadowOpacity = 0.5;\
layer.shadowRadius = 3.0;\
layer.shadowOffset = CGSizeMake(1,1);\
CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;\
view.layer.shadowPath = shadowPath;

#define SET_BORDER(view,border)\
view.layer.borderColor = [[UIColor colorWithWhite:0.882 alpha:1.000] CGColor];\
view.layer.cornerRadius = 0.5;\
view.layer.borderWidth = 1;

#define FontRegular @"Avenir"
#define FontHeavy @"Avenir-Heavy"

#define SETFont(label,fontName,fontSize)\
label.font = [UIFont fontWithName:fontName size:fontSize];
 
#define GreenColor [UIColor colorWithRed:54.0/255.0 green:128.0/255.0 blue:8.0/255.0 alpha:1.0]

#define RedColor [UIColor redColor]

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define RIGHT_PANEL_BGCOLOR UIColorFromRGB(0xF7F7F7)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define USER_DEFAULTS [NSUserDefault standardUserDefaults]

#define LineSpace ([UIFont fontWithName:FontRegular size:8])

#define fireBaseUrl @"https://incandescent-fire-1647.firebaseio.com/"

#define fireBaseSecret @"FRdGObYikPz5hOixPbJHdmqwLa5BNab5fq8E52VO"