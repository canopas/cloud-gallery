import 'package:flutter/cupertino.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class AccountsTab extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final String? profileImage;
  final String? serviceDescription;
  final Widget? actionList;

  const AccountsTab(
      {super.key,
      required this.name,
      this.serviceDescription,
      this.actionList,
      this.profileImage,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildProfileAvtar(context: context),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.subtitle2.copyWith(
                        color: context.colorScheme.textPrimary,
                      ),
                    ),
                    if (serviceDescription != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        serviceDescription ?? '',
                        style: AppTextStyles.body2.copyWith(
                          color: context.colorScheme.textSecondary,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
          if (actionList != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: actionList,
            )
        ],
      ),
    );
  }

  Widget _buildProfileAvtar({required BuildContext context}) => Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: context.colorScheme.containerNormal,
          border: Border.all(color: context.colorScheme.outline, width: 0.8),
          image: profileImage != null
              ? DecorationImage(
                  image: NetworkImage(profileImage!),
                )
              : null,
          shape: BoxShape.circle,
        ),
        child: Visibility(
          visible: profileImage == null,
          child: Icon(
            CupertinoIcons.person,
            color: context.colorScheme.textPrimary,
          ),
        ),
      );
}
