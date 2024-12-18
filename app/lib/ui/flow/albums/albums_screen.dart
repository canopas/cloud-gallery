import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/app_page.dart';

class AlbumsScreen extends ConsumerStatefulWidget {
  const AlbumsScreen({super.key});

  @override
  ConsumerState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends ConsumerState<AlbumsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Albums",
      body: ListView(
        children: [
          TextButton(
            onPressed: () {

            },
            child: Text(
              "+ Add Album",
              style: AppTextStyles.body2.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
