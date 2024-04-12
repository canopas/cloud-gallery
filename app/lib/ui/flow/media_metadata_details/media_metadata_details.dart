import 'dart:typed_data';
import 'package:cloud_gallery/components/app_page.dart';
import 'package:cloud_gallery/components/thumbnail_builder.dart';
import 'package:cloud_gallery/domain/assets/assets_paths.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/domain/formatter/byte_formatter.dart';
import 'package:cloud_gallery/domain/formatter/date_formatter.dart';
import 'package:cloud_gallery/domain/formatter/duration_formatter.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';

class MediaMetadataDetailsScreen extends StatefulWidget {
  final AppMedia media;

  const MediaMetadataDetailsScreen({super.key, required this.media});

  @override
  State<MediaMetadataDetailsScreen> createState() =>
      _MediaMetadataDetailsScreenState();
}

class _MediaMetadataDetailsScreenState
    extends State<MediaMetadataDetailsScreen> {
  Future<Uint8List?>? thumbnailByte;

  @override
  void initState() {
    if (widget.media.sources.contains(AppMediaSource.local)) {
      thumbnailByte = widget.media.loadThumbnail();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
        title: '',
        body: Builder(builder: (context) {
          return Material(
            color: Colors.transparent,
            child: ListView(
              padding: context.systemPadding,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AppMediaThumbnail(
                      size: Size(context.mediaQuerySize.width, 200),
                      thumbnailByte: thumbnailByte,
                      media: widget.media,
                      radius: 0,
                    ),
                    if (widget.media.type.isVideo)
                      Icon(Icons.play_arrow_rounded,
                          size: 50, color: context.colorScheme.onPrimary),
                  ],
                ),
                const SizedBox(height: 16),
                DetailsTile(
                  title: context.l10n.name_text,
                  subtitle: (widget.media.name?.trim().isNotEmpty ?? false)
                      ? widget.media.name!
                      : context.l10n.common_not_available,
                ),
                DetailsTile(
                  title: context.l10n.path_text,
                  subtitle: widget.media.path,
                ),
                DetailsTile(
                  title: context.l10n.created_at_text,
                  subtitle: widget.media.createdTime == null
                      ? context.l10n.common_not_available
                      : "${widget.media.createdTime?.format(context, DateFormatType.dayMonthYear)}, ${widget.media.createdTime?.format(context, DateFormatType.time)}",
                ),
                DetailsTile(
                  title: context.l10n.modified_at_text,
                  subtitle: widget.media.modifiedTime == null
                      ? context.l10n.common_not_available
                      : "${widget.media.modifiedTime?.format(context, DateFormatType.dayMonthYear)}, ${widget.media.modifiedTime?.format(context, DateFormatType.time)}",
                ),
                DetailsTile(
                  title: context.l10n.mimetype_text,
                  subtitle: widget.media.mimeType ??
                      context.l10n.common_not_available,
                ),
                DetailsTile(
                  title: context.l10n.size_text,
                  subtitle:
                      int.tryParse(widget.media.size ?? '')?.formatBytes ??
                          context.l10n.common_not_available,
                ),
                if (widget.media.type.isVideo)
                  DetailsTile(
                    title: context.l10n.duration_text,
                    subtitle: widget.media.videoDuration?.format ??
                        context.l10n.common_not_available,
                  ),
                DetailsTile(
                  title: context.l10n.location_text,
                  subtitle: widget.media.latitude == null ||
                          widget.media.longitude == null
                      ? context.l10n.common_not_available
                      : '${widget.media.latitude}, ${widget.media.longitude}',
                ),
                DetailsTile(
                  title: context.l10n.orientation_text,
                  subtitle: widget.media.orientation?.name ?? 'N/A',
                ),
                DetailsTile(
                  title: context.l10n.resolution_text,
                  subtitle: widget.media.displayHeight == null ||
                          widget.media.displayWidth == null
                      ? context.l10n.common_not_available
                      : '${widget.media.displayWidth?.toInt()} x ${widget.media.displayHeight?.toInt()}',
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
                        if (widget.media.sources.contains(AppMediaSource.local))
                          Icon(Icons.phone_android_rounded,
                              color: context.colorScheme.textSecondary,
                              size: 20),
                        if (widget.media.sources
                            .contains(AppMediaSource.googleDrive))
                          SvgPicture.asset(
                            Assets.images.icons.googleDrive,
                            width: 20,
                          )
                      ],
                    ))
              ],
            ),
          );
        }));
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
