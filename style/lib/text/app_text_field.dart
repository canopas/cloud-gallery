import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../extensions/context_extensions.dart';
import 'app_text_style.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final bool expands;
  final bool enabled;
  final BorderRadius? borderRadius;
  final AppTextFieldBorderType borderType;
  final double borderWidth;
  final TextInputAction? textInputAction;
  final String? hintText;
  final String? errorText;
  final bool? isDense;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isCollapsed;
  final TextStyle? hintStyle;
  final Function(String)? onChanged;
  final bool autoFocus;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool? filled;
  final Color? fillColor;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final Function(PointerDownEvent)? onTapOutside;
  final Function()? onTap;
  final void Function(String)? onSubmitted;

  const AppTextField({
    super.key,
    this.label,
    this.labelStyle,
    this.controller,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.expands = false,
    this.enabled = true,
    this.onChanged,
    this.borderType = AppTextFieldBorderType.outline,
    this.borderWidth = 1,
    this.textInputAction,
    this.borderRadius,
    this.hintText,
    this.hintStyle,
    this.errorText,
    this.contentPadding,
    this.isDense,
    this.isCollapsed,
    this.autoFocus = false,
    this.keyboardType,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.onTapOutside,
    this.filled = true,
    this.fillColor,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.onTap,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) =>
      label != null ? _textFieldWithLabel(context) : _textField(context);

  Widget _textFieldWithLabel(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              label!,
              style: labelStyle ??
                  AppTextStyles.body2.copyWith(
                    color: context.colorScheme.textDisabled,
                  ),
            ),
          ),
          const SizedBox(height: 6),
          _textField(context),
        ],
      );

  Widget _textField(BuildContext context) => Material(
        color: Colors.transparent,
        child: TextField(
          contextMenuBuilder:
              (BuildContext context, EditableTextState editableTextState) {
            // If supported, show the system context menu.
            if (SystemContextMenu.isSupported(context)) {
              return SystemContextMenu.editableText(
                editableTextState: editableTextState,
              );
            }
            // Otherwise, show the flutter-rendered context menu for the current
            // platform.
            return AdaptiveTextSelectionToolbar.editableText(
              editableTextState: editableTextState,
            );
          },
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          enabled: enabled,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          textInputAction: textInputAction,
          autofocus: autoFocus,
          keyboardType: keyboardType,
          focusNode: focusNode,
          textAlign: textAlign,
          textCapitalization: TextCapitalization.sentences,
          style: style ??
              AppTextStyles.subtitle1.copyWith(
                color: context.colorScheme.textPrimary,
              ),
          onTapOutside: onTapOutside ??
              (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
          decoration: InputDecoration(
            hintFadeDuration: const Duration(milliseconds: 300),
            filled: filled,
            fillColor: fillColor ?? context.colorScheme.containerLow,
            isDense: isDense,
            isCollapsed: isCollapsed,
            hintText: hintText,
            hintStyle: hintStyle ??
                AppTextStyles.body.copyWith(
                  color: context.colorScheme.textDisabled,
                ),
            focusedBorder: _border(context, true),
            enabledBorder: _border(context, false),
            disabledBorder: _border(context, false),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13.5,
                ),
            prefixIcon: prefix,
            suffix: suffix,
            errorText: errorText,
          ),
        ),
      );

  InputBorder _border(BuildContext context, bool focused) {
    switch (borderType) {
      case AppTextFieldBorderType.none:
        return const UnderlineInputBorder(
          borderSide: BorderSide.none,
        );
      case AppTextFieldBorderType.outline:
        return OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          borderSide: BorderSide(
            color: focused
                ? context.colorScheme.primary
                : context.colorScheme.outline,
            width: borderWidth,
          ),
        );
      case AppTextFieldBorderType.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: focused
                ? context.colorScheme.primary
                : context.colorScheme.outline,
            width: borderWidth,
          ),
        );
    }
  }
}

enum AppTextFieldBorderType {
  none,
  outline,
  underline,
}
