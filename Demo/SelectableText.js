import React from 'react'
import ReactNative, { TextInput, requireNativeComponent, NativeModules } from 'react-native'

const RNSelectableText = requireNativeComponent('RNSelectableText')

export class SelectableText extends React.Component {
  constructor(props) {
    super(props);
    // this.setNativeProps = this.setNativeProps.bind(this);
  }

  componentDidMount() {
    this._inputReactTag = this.textInputReactTag();
    if (this._inputReactTag){
      NativeModules.RNSelectableTextManager.setupMenuItems(
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
    return <RNSelectableText menuItems={this.props.menuItems} 
      inputReactTag={this._inputReactTag} onSelection={this.onSelectionNative}>
      <TextInput 
        {...this.props} 
        {...this.style} 
        style={[this.props.style, {height: 'auto'}]} 
        ref={(r) => { this._textInput = r; }}>
          {this.props.children}
      </TextInput>
    </RNSelectableText>
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