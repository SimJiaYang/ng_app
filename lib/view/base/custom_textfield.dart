import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurserygardenapp/util/color_resources.dart';
import 'package:nurserygardenapp/util/dimensions.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int? maxLines;
  final bool autoFocus;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final GestureTapCallback? onTap;
  final ValueChanged? onChanged;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final Widget? prefixIconUrl;
  final bool isSearch;
  final ValueChanged? onSubmit;
  final bool isEnabled;
  final bool isReadOnly;
  final TextCapitalization capitalization;
  final InputDecoration? inputDecoration;
  final String? label;
  final List<TextInputFormatter>? inputFormatter;
  final bool isApplyValidator;
  final int? maxLength;
  final String? validateMessage;
  final Function(dynamic)? validation;
  final bool? isPasswordValidator;

  CustomTextField({
    this.hintText = 'Write something...',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.autoFocus = false,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTap,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIconUrl,
    this.prefixIconUrl,
    this.isSearch = false,
    this.isReadOnly = false,
    this.inputDecoration,
    this.inputFormatter,
    this.isApplyValidator = true,
    this.maxLength,
    this.validateMessage,
    this.validation,
    this.label,
    this.isPasswordValidator = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  OutlineInputBorder _outlineInputBorderShow = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
        width: 1,
        color: ColorResources.COLOR_GREY_CHATEAU,
        style: BorderStyle.solid),
  );
  OutlineInputBorder _outlineInputBorderHided = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: ColorResources.COLOR_GREY_CHATEAU,
      style: BorderStyle.solid,
      width: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength == null ? null : widget.maxLength,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: Dimensions.FONT_SIZE_LARGE),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      readOnly: widget.isReadOnly,
      autofocus: widget.autoFocus,
      //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
            ]
          : widget.inputType == TextInputType.number
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ]
              : widget.inputFormatter,
      decoration: widget.inputDecoration ??
          InputDecoration(
            floatingLabelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            labelStyle: TextStyle(color: const Color.fromARGB(255, 27, 31, 37)),
            focusColor: Theme.of(context).primaryColor,
            label: widget.label != null ? Text(widget.label!) : null,
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
            focusedBorder: _outlineInputBorderHided,
            enabledBorder: widget.isShowBorder
                ? _outlineInputBorderShow
                : _outlineInputBorderHided,
            border: widget.isShowBorder
                ? _outlineInputBorderShow
                : _outlineInputBorderHided,
            isDense: true,
            hintText: widget.hintText,
            fillColor: widget.fillColor != null
                ? widget.fillColor
                : Theme.of(context).cardColor,
            hintStyle: TextStyle(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: ColorResources.COLOR_GREY_CHATEAU),
            filled: true,
            prefixIcon: widget.isShowPrefixIcon
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: Dimensions.PADDING_SIZE_LARGE,
                        right: Dimensions.PADDING_SIZE_SMALL),
                    child: widget.prefixIconUrl,
                  )
                : SizedBox.shrink(),
            prefixIconConstraints: BoxConstraints(minWidth: 23, maxHeight: 20),
            suffixIcon: widget.isShowSuffixIcon
                ? widget.isPassword
                    ? IconButton(
                        icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: ColorResources.COLOR_GREY_CHATEAU),
                        onPressed: _toggle)
                    : widget.isIcon
                        ? IconButton(
                            onPressed: widget.onSuffixTap,
                            icon: Image.asset(
                              widget.suffixIconUrl!,
                              width: 15,
                              height: 15,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          )
                        : null
                : null,
          ),
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(widget.nextFocus);
      },
      validator: widget.isApplyValidator
          ? (value) {
              if (value == null || value.isEmpty) {
                return widget.validateMessage == null
                    ? 'Please enter a value'
                    : widget.validateMessage;
              } else {
                if (widget.inputType == TextInputType.emailAddress) {
                  if (checkEmail(value)) {
                    if (widget.validateMessage == null) {
                      return 'Please enter valid email';
                    } else {
                      return widget.validateMessage;
                    }
                  }
                }
                if (widget.isPasswordValidator!) {
                  if (value.length < 8) {
                    return 'Password should be more than 7 words';
                  }
                }
              }
              return null;
            }
          : null,
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool checkEmail(String email) {
    return !RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
