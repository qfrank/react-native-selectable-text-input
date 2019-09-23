#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#else
#import "RCTBridge.h"
#endif

#if __has_include(<React/RCTView.h>)
#import <React/RCTView.h>
#else
#import "RCTView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNSelectableTextView : RCTView

-(instancetype)initWithFrame:(CGRect)frame andBridge: (RCTBridge *)bridge;
@property (nonatomic, copy) RCTDirectEventBlock onSelection;
@property (nullable, nonatomic, copy) NSArray<NSString *> *menuItems;
-(void)setupView:(nonnull NSNumber *)textInputReactTag;

@end

NS_ASSUME_NONNULL_END
