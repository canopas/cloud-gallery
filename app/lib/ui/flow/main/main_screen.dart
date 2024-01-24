import 'package:cloud_gallery/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:style/text/app_text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: Center(
          child: Text('Home Screen',
              style: AppTextStyles.subtitle2
                  .copyWith(color: context.colorScheme.textPrimary))),
    );
  }
}
