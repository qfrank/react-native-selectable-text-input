#if __has_include(<RCTText/RCTTextSelection.h>)
#import <RCTText/RCTTextSelection.h>
#else
#import "RCTTextSelection.h"
#endif

#if __has_include(<RCTText/RCTUITextView.h>)
#import <RCTText/RCTUITextView.h>
#else
#import "RCTUITextView.h"
#endif

#if __has_include(<RCTText/RCTBaseTextInputView.h>)
#import <RCTText/RCTBaseTextInputView.h>
#else
#import "RCTBaseTextInputView.h"
#endif

#import <React/RCTUtils.h>
#import <React/RCTUIManager.h>
#import "RNSelectableTextView.h"

@implementation RNSelectableTextView
{
    RCTBaseTextInputView *_baseTextInputView;
    RCTUITextView *_backedTextInputView;
    RCTBridge *_bridge;
}

NSString *const CUSTOM_SELECTOR = @"_CUSTOM_SELECTOR_";

- (instancetype)initWithFrame:(CGRect)frame andBridge: (RCTBridge *)bridge
{
    if ((self = [super initWithFrame:frame])) {
        _bridge = bridge;
    }
    return self;
}

-(void)setupView:(nonnull NSNumber *)textInputReactTag {
    UIView *_textView = [_bridge.uiManager viewForReactTag:textInputReactTag];
    _baseTextInputView = (RCTBaseTextInputView*)_textView;
    _backedTextInputView = [_textView valueForKey:@"_backedTextInputView"];
    
    for (UIGestureRecognizer *gesture in [_backedTextInputView gestureRecognizers]) {
        if (
            [gesture isKindOfClass:[UIPanGestureRecognizer class]]
            ) {
            [_backedTextInputView setExclusiveTouch:NO];
            gesture.enabled = YES;
        } else {
            gesture.enabled = NO;
        }
    }
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    UITapGestureRecognizer *tapGesture = [ [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 2;
    
    //UITapGestureRecognizer *singleTapGesture = [ [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //singleTapGesture.numberOfTapsRequired = 1;
    
    [_backedTextInputView addGestureRecognizer:longPressGesture];
    [_backedTextInputView addGestureRecognizer:tapGesture];
    //[_backedTextInputView addGestureRecognizer:singleTapGesture];
    
    [self setUserInteractionEnabled:YES];
}

-(void) _handleGesture
{
    if (!_backedTextInputView.isFirstResponder) {
        [_backedTextInputView becomeFirstResponder];
    }
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController.isMenuVisible) return;
    
    NSMutableArray *menuControllerItems = [NSMutableArray arrayWithCapacity:self.menuItems.count];
    
    for(NSString *menuItemName in self.menuItems) {
        NSString *sel = [NSString stringWithFormat:@"%@%@", CUSTOM_SELECTOR, menuItemName];
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle: menuItemName
                                                      action: NSSelectorFromString(sel)];
        
        [menuControllerItems addObject: item];
    }
    
    menuController.menuItems = menuControllerItems;
    [menuController setTargetRect:self.bounds inView:self];
    [menuController setMenuVisible:YES animated:YES];
}

-(void) handleLongPress: (UILongPressGestureRecognizer *) gesture
{
    CGPoint pos = [gesture locationInView:_backedTextInputView];
    pos.y += _backedTextInputView.contentOffset.y;
    
    UITextPosition *tapPos = [_backedTextInputView closestPositionToPoint:pos];
    UITextRange *word = [_backedTextInputView.tokenizer rangeEnclosingPosition:tapPos withGranularity:(UITextGranularityWord) inDirection:UITextLayoutDirectionRight];
    
    UITextPosition* beginning = _backedTextInputView.beginningOfDocument;
    
    UITextPosition *selectionStart = word.start;
    UITextPosition *selectionEnd = word.end;
    
    const NSInteger location = [_backedTextInputView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger endLocation = [_backedTextInputView offsetFromPosition:beginning toPosition:selectionEnd];
    
    if (location == 0 && endLocation == 0) return;
    
    [_backedTextInputView select:self];
    [_backedTextInputView setSelectedRange:NSMakeRange(location, endLocation - location)];
    [self _handleGesture];
}

- (void)tappedMenuItem:(NSString *)eventType
{
    RCTTextSelection *selection = _baseTextInputView.selection;
    
    NSUInteger start = selection.start;
    NSUInteger end = selection.end - selection.start;
    
    self.onSelection(@{
                       @"content": [[_baseTextInputView.attributedText string] substringWithRange:NSMakeRange(start, end)],
                       @"eventType": eventType,
                       @"selectionStart": @(start),
                       @"selectionEnd": @(selection.end)
                       });
    
    [_backedTextInputView setSelectedTextRange:nil notifyDelegate:false];
}

-(void) handleTap: (UITapGestureRecognizer *) gesture
{
    [_backedTextInputView select:self];
    [_backedTextInputView selectAll:self];
    [self _handleGesture];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    if ([super methodSignatureForSelector:sel]) {
        return [super methodSignatureForSelector:sel];
    }
    return [super methodSignatureForSelector:@selector(tappedMenuItem:)];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *sel = NSStringFromSelector([invocation selector]);
    NSRange match = [sel rangeOfString:CUSTOM_SELECTOR];
    if (match.location == 0) {
        [self tappedMenuItem:[sel substringFromIndex:17]];
    } else {
        [super forwardInvocation:invocation];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSString *sel = NSStringFromSelector(action);
    NSRange match = [sel rangeOfString:CUSTOM_SELECTOR];
    
    if (match.location == 0) {
        return YES;
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [_backedTextInputView setSelectedTextRange:nil notifyDelegate:true];
    return [super hitTest:point withEvent:event];
}

@end
