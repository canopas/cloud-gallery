import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/extensions/column_extension.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class AccountsTab extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final String? profileImage;
  final String? serviceDescription;
  final List<Widget>? actions;

  const AccountsTab({
    super.key,
    required this.name,
    this.serviceDescription,
    this.actions,
    this.profileImage,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor.withAlpha(50),
            backgroundColor.withAlpha(40),
          ],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildProfileAvtar(context: context),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.subtitle2.copyWith(
                          color: context.colorScheme.textPrimary,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (serviceDescription != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          serviceDescription ?? '',
                          style: AppTextStyles.body2.copyWith(
                            color: context.colorScheme.textSecondary,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (actions != null) ...[
            Divider(
              color: context.colorScheme.outline,
              height: 0,
              thickness: 0.8,
              indent: 16,
              endIndent: 16,
            ),
            ColumnBuilder.separated(
              itemCount: actions!.length,
              itemBuilder: (index) => actions![index],
              separatorBuilder: (index) => Divider(
                color: context.colorScheme.outline,
                height: 0,
                thickness: 0.8,
                indent: 16,
                endIndent: 16,
              ),
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ],
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
                  image: CachedNetworkImageProvider(profileImage!),
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
