import 'package:cloud_gallery/components/app_page.dart';
import 'package:flutter/cupertino.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return const AppPage(
      title: '',
      body: Center(
        child: Text("Accounts"),
      ),
    );
  }
}
