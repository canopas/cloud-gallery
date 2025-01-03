import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style/extensions/context_extensions.dart';
import '../../navigation/app_route.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final tabs = [
      (
        icon: CupertinoIcons.house_fill,
        label: "Home",
        activeIcon: CupertinoIcons.house_fill,
      ),
      (
        icon: CupertinoIcons.folder,
        label: "Albums",
        activeIcon: CupertinoIcons.folder_fill
      ),
      (
        icon: CupertinoIcons.arrow_up_arrow_down,
        label: "Transfer",
        activeIcon: CupertinoIcons.arrow_up_arrow_down
      ),
      (
        icon: CupertinoIcons.person,
        label: "Account",
        activeIcon: CupertinoIcons.person_fill
      ),
    ];

    return Column(
      children: [
        Expanded(child: widget.navigationShell),
        (!kIsWeb && Platform.isIOS)
            ? CupertinoTabBar(
                currentIndex: widget.navigationShell.currentIndex,
                activeColor: context.colorScheme.primary,
                inactiveColor: context.colorScheme.textDisabled,
                onTap: (index) => _goBranch(
                  index: index,
                  context: context,
                ),
                backgroundColor: context.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: context.colorScheme.outline,
                    width: 1,
                  ),
                ),
                items: tabs
                    .map(
                      (e) => BottomNavigationBarItem(
                        icon: Icon(
                          e.icon,
                          color: context.colorScheme.textDisabled,
                          size: 22,
                        ),
                        label: e.label,
                        activeIcon: Icon(
                          e.activeIcon,
                          color: context.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    )
                    .toList(),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
                  items: tabs
                      .map(
                        (e) => BottomNavigationBarItem(
                          icon: Icon(
                            e.icon,
                            color: context.colorScheme.textDisabled,
                            size: 24,
                          ),
                          label: e.label,
                          activeIcon: Icon(
                            e.activeIcon,
                            color: context.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      )
                      .toList(),
                  currentIndex: widget.navigationShell.currentIndex,
                  selectedItemColor: context.colorScheme.primary,
                  unselectedItemColor: context.colorScheme.textDisabled,
                  backgroundColor: context.colorScheme.surface,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  elevation: 0,
                  onTap: (index) => _goBranch(
                    index: index,
                    context: context,
                  ),
                ),
              ),
      ],
    );
  }

  void _goBranch({
    required int index,
    required BuildContext context,
  }) {
    switch (index) {
      case 0:
        HomeRoute().go(context);
        break;
      case 1:
        AlbumsRoute().go(context);
        break;
      case 2:
        TransferRoute().go(context);
        break;
      case 3:
        AccountRoute().go(context);
        break;
    }
  }
}
