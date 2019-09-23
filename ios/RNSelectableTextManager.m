#if __has_include(<React/RCTUIManager.h>)
#import <React/RCTUIManager.h>
#else
#import "RCTUIManager.h"
#endif

#import "RNSelectableTextView.h"
#import "RNSelectableTextManager.h"

@implementation RNSelectableTextManager

RCT_EXPORT_MODULE()

- (UIView *)view
{
    RNSelectableTextView *selectable = [[RNSelectableTextView alloc] initWithFrame:self.accessibilityFrame andBridge: self.bridge];
    return selectable;
}

RCT_EXPORT_VIEW_PROPERTY(onSelection, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(menuItems, NSArray);

RCT_EXPORT_METHOD(setupMenuItems:(nonnull NSNumber*) selectableTextViewReactTag textInputReactTag:(nonnull NSNumber*) textInputReactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        
        UIView *view = viewRegistry[selectableTextViewReactTag];
        if (!view || ![view isKindOfClass:[RNSelectableTextView class]]) {
            RCTLogError(@"Cannot find NativeView with tag #%@", selectableTextViewReactTag);
            return;
        }
        
        RNSelectableTextView *selectableTextView = (RNSelectableTextView*)view;
        [selectableTextView setupView:textInputReactTag];
    }];
    
}

#pragma mark - Multiline <TextInput> (aka TextView) specific properties

#if !TARGET_OS_TV
RCT_REMAP_VIEW_PROPERTY(dataDetectorTypes, backedTextInputView.dataDetectorTypes, UIDataDetectorTypes)
#endif

@end
