import 'package:data/models/album/album.dart';
import 'package:data/models/media/media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style/animations/fade_in_switcher.dart';
import 'package:style/animations/on_tap_scale.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../../components/thumbnail_builder.dart';
import '../../../../gen/assets.gen.dart';

class AlbumItem extends StatelessWidget {
  final Album album;
  final AppMedia? media;
  final void Function() onTap;
  final void Function() onLongTap;

  const AlbumItem({
    super.key,
    required this.album,
    required this.media,
    required this.onTap,
    required this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return OnTapScale(
      onTap: onTap,
      onLongTap: onLongTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FadeInSwitcher(
              child: media == null
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colorScheme.containerLowOnSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.colorScheme.outline,
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.folder,
                        size: 80,
                        color: context.colorScheme.containerHighOnSurface,
                      ),
                    )
                  : AppMediaImage(
                      heroTag: "album${media.toString()}",
                      radius: 8,
                      media: media!,
                      size: Size(double.infinity, double.infinity),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                if (album.source == AppMediaSource.dropbox) ...[
                  SvgPicture.asset(
                    Assets.images.icDropbox,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 4),
                ],
                if (album.source == AppMediaSource.googleDrive) ...[
                  SvgPicture.asset(
                    Assets.images.icGoogleDrive,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    album.name,
                    style: AppTextStyles.subtitle1.copyWith(
                      color: context.colorScheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
