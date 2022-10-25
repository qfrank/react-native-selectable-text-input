import React from 'react'
import ReactNative, { TextInput, requireNativeComponent, NativeModules } from 'react-native'

const RNSelectableTextInput = requireNativeComponent('RNSelectableTextInput')

export class SelectableTextInput extends React.Component {
  constructor(props) {
    super(props);
    // this.setNativeProps = this.setNativeProps.bind(this);
  }

  componentDidMount() {
    this._inputReactTag = this.textInputReactTag();
    if (this._inputReactTag){
      NativeModules.RNSelectableTextInputManager.setupMenuItems(
        ReactNative.findNodeHandle(this), 
        this._inputReactTag)
    }
  }

  textInputReactTag() {
    if (this._textInput) {
      return ReactNative.findNodeHandle(this._textInput);
    }
  }

  onSelectionNative = ({
    nativeEvent: { content, eventType, selectionStart, selectionEnd },
  }) => {
    this.props.onSelection && this.props.onSelection({ content, eventType, selectionStart, selectionEnd })
  }

  render() {
    return <RNSelectableTextInput menuItems={this.props.menuItems} 
      inputReactTag={this._inputReactTag}>
      <TextInput 
        {...this.props} 
        {...this.style} 
        style={[this.props.style, {height: 'auto'}]} 
        ref={(r) => { this._textInput = r; }}
        onSelection={this.onSelectionNative}>
          {this.props.children}
      </TextInput>
    </RNSelectableTextInput>
  }

  // setNativeProps(nativeProps = {}) {
  //   if (this._textInput) {
  //     this._textInput.setNativeProps(nativeProps);
  //   }
  // }

  clear() {
    return this._textInput.clear();
  }

  focus() {
    return this._textInput.focus();
  }

  blur() {
    this._textInput.blur();
  }

  isFocused() {
    return this._textInput.isFocused();
  }

  // getRef() {
  //   return this._textInput;
  // }
}