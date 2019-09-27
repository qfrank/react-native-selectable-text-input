package com.astrocoders.selectabletext;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIBlock;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.views.text.ReactTextView;
import com.facebook.react.views.textinput.ReactEditText;

import javax.annotation.Nonnull;

class RNSelectableTextModule extends ReactContextBaseJavaModule {
    public RNSelectableTextModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Nonnull
    @Override
    public String getName() {
        return "RNSelectableTextManager";
    }

    @ReactMethod
    public void setupMenuItems(final Integer selectableTextViewReactTag, final Integer textInputReactTag) {
        ReactApplicationContext reactContext = this.getReactApplicationContext();
        UIManagerModule uiManager = reactContext.getNativeModule(UIManagerModule.class);
        uiManager.addUIBlock(new UIBlock() {
            public void execute (NativeViewHierarchyManager nvhm) {
                RNSelectableTextViewManager rnSelectableTextManager = (RNSelectableTextViewManager) nvhm.resolveViewManager(selectableTextViewReactTag);
                ReactEditText reactTextView = (ReactEditText) nvhm.resolveView(textInputReactTag);
                rnSelectableTextManager.registerSelectionListener(reactTextView);
            }
        });
    }
}
