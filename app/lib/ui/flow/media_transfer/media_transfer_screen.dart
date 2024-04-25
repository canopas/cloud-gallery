import 'package:cloud_gallery/components/error_view.dart';
import 'package:cloud_gallery/domain/extensions/context_extensions.dart';
import 'package:cloud_gallery/ui/flow/media_transfer/components/transfer_item.dart';
import 'package:cloud_gallery/ui/flow/media_transfer/media_transfer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:style/buttons/segmented_button.dart';
import 'package:style/extensions/context_extensions.dart';
import 'package:style/text/app_text_style.dart';
import '../../../components/app_page.dart';

class MediaTransferScreen extends ConsumerStatefulWidget {
  const MediaTransferScreen({super.key});

  @override
  ConsumerState createState() => _MediaTransferScreenState();
}

class _MediaTransferScreenState extends ConsumerState<MediaTransferScreen> {
  late MediaTransferStateNotifier notifier;
  late PageController pageController;

  @override
  void initState() {
    notifier = ref.read(mediaTransferStateNotifierProvider.notifier);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(
        mediaTransferStateNotifierProvider.select((value) => value.page));
    return AppPage(
      title: context.l10n.transfer_screen_title,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: context.mediaQuerySize.width,
                child: AppSegmentedButton(
                  segmentTextStyle: AppTextStyles.body,
                  tapTargetSize: MaterialTapTargetSize.padded,
                  segments: [
                    AppButtonSegment(
                        value: 0, label: context.l10n.common_upload),
                    AppButtonSegment(
                        value: 1, label: context.l10n.common_download),
                  ],
                  selected: page,
                  onSelectionChanged: (value) {
                    notifier.onPageChange(value);
                    pageController.animateToPage(
                      value,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
            Divider(color: context.colorScheme.outline, height: 0.8),
            Expanded(
                child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                notifier.onPageChange(value);
              },
              children: [
                _uploadList(),
                _downloadList(),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _uploadList() {
    return Consumer(builder: (context, ref, child) {
      final upload = ref.watch(
          mediaTransferStateNotifierProvider.select((value) => value.upload));

      if (upload.isEmpty) {
        return ErrorView(
          title: context.l10n.empty_upload_title,
          message: context.l10n.empty_upload_message,
          icon: Icon(Icons.cloud_upload_outlined,
              size: 100, color: context.colorScheme.containerNormal),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: upload.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 8,
        ),
        itemBuilder: (context, index) => ProcessItem(
            key: ValueKey(upload[index].id),
            process: upload[index],
            onCancelTap: () {
              notifier.onTerminateUploadProcess(upload[index].id);
            }),
      );
    });
  }

  Widget _downloadList() {
    return Consumer(builder: (context, ref, child) {
      final download = ref.watch(
        mediaTransferStateNotifierProvider.select((value) => value.download),
      );

      if (download.isEmpty) {
        return ErrorView(
          title: context.l10n.empty_download_title,
          message: context.l10n.empty_download_message,
          icon: Icon(Icons.cloud_download_outlined,
              size: 100, color: context.colorScheme.containerNormal),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: download.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 8,
        ),
        itemBuilder: (context, index) => ProcessItem(
          key: ValueKey(download[index].id),
          process: download[index],
          onCancelTap: () {
            notifier.onTerminateDownloadProcess(download[index].id);
          },
        ),
      );
    });
  }
}
