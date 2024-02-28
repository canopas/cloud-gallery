import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:data/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import 'package:style/theme/colors.dart';
import 'package:style/buttons/buttons_list.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    final googleAccount =
        ref.read(authServiceProvider.select((value) => value.user));
    return AppPage(
      title: context.l10n.common_accounts,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AccountsTab(
            name: googleAccount?.displayName ?? 'Add account',
            accountSource: context.l10n.common_google_drive,
            profileImage: googleAccount?.photoUrl,
          ),
          const SizedBox(height: 16),
          ActionList(buttons: [
            ActionListButton(title: context.l10n.common_term_and_condition, onPressed: (){}),
            ActionListButton(title: context.l10n.common_privacy_policy, onPressed: (){}),
          ]),
          const SizedBox(height: 16),
          Text(
            "Version: 1.0.0",
            style: AppTextStyles.body2.copyWith(
              color: context.colorScheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class AccountsTab extends StatefulWidget {
  final String name;
  final String? profileImage;
  final String accountSource;

  const AccountsTab(
      {super.key,
      required this.name,
      required this.accountSource,
       this.profileImage});

  @override
  State<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.googleDriveColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      color: context.colorScheme.containerNormal,
                      border:
                          Border.all(color: context.colorScheme.outline, width: 0.8),
                      image: widget.profileImage != null?DecorationImage(
                        image: NetworkImage(widget.profileImage!)
                      ):null,
                      shape: BoxShape.circle),
                  child: Visibility(
                    visible: widget.profileImage == null,
                    child: Icon(
                      CupertinoIcons.person,
                      color: context.colorScheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppTextStyles.subtitle2.copyWith(
                        color: context.colorScheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.accountSource,
                      style: AppTextStyles.body2.copyWith(
                        color: context.colorScheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ActionList(buttons: [
              ActionListButton(title: "Auto Back-up", trailing: Material(
                color: Colors.transparent,
                child: Switch.adaptive(
                  value: val ,
                  onChanged: (value) {
                    setState((){});
                    val = value;
                  },
                  activeColor: context.colorScheme.positive,
                  thumbColor: MaterialStateProperty.all(context.colorScheme.surface),
                  inactiveTrackColor: context.colorScheme.containerNormal,
                ),
              )),
              ActionListButton(title: "Sign Out", onPressed: (){}),
            ]),
          )
        ],
      ),
    );
  }
}

bool val = false;