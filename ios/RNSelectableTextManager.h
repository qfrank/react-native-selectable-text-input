#import <React/RCTViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNSelectableTextManager : RCTViewManager

@property (nonatomic, copy) RCTDirectEventBlock onSelection;
@property (nullable, nonatomic, copy) NSArray<NSString *> *menuItems;

@end

NS_ASSUME_NONNULL_END
