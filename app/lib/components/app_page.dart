import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;
  final Widget? body;
  final bool automaticallyImplyLeading;
  final bool? resizeToAvoidBottomInset;

  const AppPage({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.body,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset,
    this.automaticallyImplyLeading = true,
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
                leading: leading,
                middle: titleWidget ?? _title(context),
                border: null,
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
        resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            body ?? const SizedBox(),
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
                title: titleWidget ?? _title(context),
                actions: actions,
                leading: leading,
                automaticallyImplyLeading: automaticallyImplyLeading,
              ),
        body: body,
        floatingActionButton: floatingActionButton,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      );

  Widget _title(BuildContext context) => Text(
        title ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
}
