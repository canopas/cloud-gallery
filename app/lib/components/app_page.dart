import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/context_extensions.dart';

class AppPage extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? body;
  final Widget Function(BuildContext context)? bodyBuilder;
  final bool automaticallyImplyLeading;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final Color? barBackgroundColor;

  const AppPage({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.body,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.bodyBuilder,
    this.automaticallyImplyLeading = true,
    this.barBackgroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return _buildCupertinoScaffold(context);
    } else {
      return _buildMaterialScaffold(context);
    }
  }

  Widget _buildCupertinoScaffold(BuildContext context) => CupertinoPageScaffold(
        navigationBar: (title == null && titleWidget == null) &&
                actions == null &&
                leading == null
            ? null
            : CupertinoNavigationBar(
                backgroundColor: barBackgroundColor,
                leading: leading,
                middle: titleWidget ?? _title(context),
                border: null,
                enableBackgroundFilterBlur: false,
                trailing: actions == null
                    ? null
                    : actions!.length == 1
                        ? actions!.first
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions!,
                          ),
                automaticallyImplyLeading: automaticallyImplyLeading,
                previousPageTitle: automaticallyImplyLeading
                    ? MaterialLocalizations.of(context).backButtonTooltip
                    : null,
              ),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            body ??
                Builder(
                  builder: (context) =>
                      bodyBuilder?.call(context) ?? const SizedBox(),
                ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: floatingActionButton ?? const SizedBox(),
              ),
            ),
          ],
        ),
      );

  Widget _buildMaterialScaffold(BuildContext context) => Scaffold(
        appBar: (title == null && titleWidget == null) &&
                actions == null &&
                leading == null
            ? null
            : AppBar(
                centerTitle: true,
                backgroundColor: barBackgroundColor,
                scrolledUnderElevation: 0.5,
                shadowColor: context.colorScheme.textDisabled,
                title: titleWidget ?? _title(context),
                actions: [...?actions, const SizedBox(width: 16)],
                leading: leading,
                automaticallyImplyLeading: automaticallyImplyLeading,
              ),
        body: body ??
            Builder(
              builder: (context) =>
                  bodyBuilder?.call(context) ?? const SizedBox(),
            ),
        backgroundColor: backgroundColor,
        floatingActionButton: floatingActionButton,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      );

  Widget _title(BuildContext context) => Text(
        title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
}

class AdaptiveAppBar extends StatelessWidget {
  final String text;
  final Widget? leading;
  final List<Widget>? actions;
  final bool iosTransitionBetweenRoutes;
  final bool automaticallyImplyLeading;

  const AdaptiveAppBar({
    super.key,
    required this.text,
    this.leading,
    this.actions,
    this.iosTransitionBetweenRoutes = true,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS || Platform.isMacOS
        ? CupertinoNavigationBar(
            transitionBetweenRoutes: iosTransitionBetweenRoutes,
            middle: Text(text),
            previousPageTitle:
                MaterialLocalizations.of(context).backButtonTooltip,
            automaticallyImplyLeading: automaticallyImplyLeading,
            leading: leading,
            trailing: actions == null
                ? null
                : actions!.length == 1
                    ? actions!.first
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      ),
          )
        : Column(
            children: [
              AppBar(
                centerTitle: true,
                backgroundColor: context.colorScheme.surface,
                leading: leading,
                actions: actions,
                automaticallyImplyLeading: automaticallyImplyLeading,
                title: Text(text),
              ),
            ],
          );
  }
}
