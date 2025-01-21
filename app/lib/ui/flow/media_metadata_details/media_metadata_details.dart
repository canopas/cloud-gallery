import '../../../domain/extensions/context_extensions.dart';
import '../../../domain/formatter/date_formatter.dart';
import '../../../domain/formatter/duration_formatter.dart';
import 'package:data/domain/formatters/byte_formatter.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../gen/assets.gen.dart';

class MediaMetadataDetailsScreen extends StatelessWidget {
  final AppMedia media;

  const MediaMetadataDetailsScreen({super.key, required this.media});

  static Future show(BuildContext context, AppMedia media) {
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      useSafeArea: true,
      builder: (context) => MediaMetadataDetailsScreen(media: media),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) => ListView(
        controller: scrollController,
        padding: context.systemPadding + const EdgeInsets.only(bottom: 16),
        children: [
          Center(
            child: Text(
              context.l10n.common_info,
              style: AppTextStyles.header4.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            ),
          ),
          Divider(
            height: 32,
            color: context.colorScheme.outline,
          ),
          DetailsTile(
            title: context.l10n.name_text,
            subtitle: (media.name?.trim().isNotEmpty ?? false)
                ? media.name!
                : context.l10n.common_not_available,
          ),
          DetailsTile(
            title: context.l10n.path_text,
            subtitle: media.path,
          ),
          DetailsTile(
            title: context.l10n.created_at_text,
            subtitle: media.createdTime == null
                ? context.l10n.common_not_available
                : "${media.createdTime?.format(context, DateFormatType.dayMonthYear)}, ${media.createdTime?.format(context, DateFormatType.time)}",
          ),
          DetailsTile(
            title: context.l10n.modified_at_text,
            subtitle: media.modifiedTime == null
                ? context.l10n.common_not_available
                : "${media.modifiedTime?.format(context, DateFormatType.dayMonthYear)}, ${media.modifiedTime?.format(context, DateFormatType.time)}",
          ),
          DetailsTile(
            title: context.l10n.mimetype_text,
            subtitle: media.mimeType ?? context.l10n.common_not_available,
          ),
          DetailsTile(
            title: context.l10n.size_text,
            subtitle: int.tryParse(media.size ?? '')?.formatBytes ??
                context.l10n.common_not_available,
          ),
          if (media.type.isVideo)
            DetailsTile(
              title: context.l10n.duration_text,
              subtitle: media.videoDuration?.format ??
                  context.l10n.common_not_available,
            ),
          DetailsTile(
            title: context.l10n.location_text,
            subtitle: media.latitude == null || media.longitude == null
                ? context.l10n.common_not_available
                : '${media.latitude}, ${media.longitude}',
          ),
          DetailsTile(
            title: context.l10n.orientation_text,
            subtitle: media.orientation?.name ?? 'N/A',
          ),
          DetailsTile(
            title: context.l10n.resolution_text,
            subtitle: media.displayHeight == null || media.displayWidth == null
                ? context.l10n.common_not_available
                : '${media.displayWidth?.toInt()} x ${media.displayHeight?.toInt()}',
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            dense: true,
            title: Text(
              context.l10n.source_text,
              style: AppTextStyles.body.copyWith(
                color: context.colorScheme.textPrimary,
              ),
            ),
            subtitle: Row(
              children: [
                if (media.sources.contains(AppMediaSource.local))
                  Icon(
                    Icons.phone_android_rounded,
                    color: context.colorScheme.textSecondary,
                    size: 20,
                  ),
                if (media.sources.contains(AppMediaSource.googleDrive))
                  SvgPicture.asset(
                    Assets.images.icGoogleDrive,
                    width: 20,
                  ),
                if (media.sources.contains(AppMediaSource.dropbox))
                  SvgPicture.asset(
                    Assets.images.icDropbox,
                    width: 20,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const DetailsTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          color: context.colorScheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.body2.copyWith(
          color: context.colorScheme.textSecondary,
        ),
      ),
    );
  }
}
