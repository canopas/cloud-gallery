import 'package:cloud_gallery/ui/flow/main/main_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Button()],
              ),
        ));
  }
}

class Button extends ConsumerWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mainScreenViewNotifierProvider.notifier);
    return TextButton(
        onPressed: () {
          notifier.getFiles();
        },
        child: const Text("Get DriveFiles"));
  }
}
