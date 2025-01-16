import 'package:flutter_svg/svg.dart';
import '../../../components/place_holder_screen.dart';
import '../../../domain/extensions/context_extensions.dart';
import '../../../gen/assets.gen.dart';
import 'components/transfer_item.dart';
import 'media_transfer_view_model.dart';
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
      mediaTransferStateNotifierProvider.select((value) => value.page),
    );
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
                      value: 0,
                      label: context.l10n.common_upload,
                    ),
                    AppButtonSegment(
                      value: 1,
                      label: context.l10n.common_download,
                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadList() {
    return Consumer(
      builder: (context, ref, child) {
        final uploadProcesses = ref.watch(
          mediaTransferStateNotifierProvider
              .select((value) => value.uploadProcesses),
        );

        if (uploadProcesses.isEmpty) {
          return PlaceHolderScreen(
            title: context.l10n.empty_upload_title,
            message: context.l10n.empty_upload_message,
            icon: SvgPicture.asset(
              Assets.images.ilUpload,
              height: 200,
              width: 200,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: uploadProcesses.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
          itemBuilder: (context, index) => UploadProcessItem(
            key: ValueKey(uploadProcesses[index].id),
            process: uploadProcesses[index],
            onResumeTap: () {
              notifier.onResumeUploadProcess(uploadProcesses[index].id);
            },
            onPausedTap: () {
              notifier.onPauseUploadProcess(uploadProcesses[index].id);
            },
            onRemoveTap: () {
              notifier.onRemoveUploadProcess(uploadProcesses[index].id);
            },
            onCancelTap: () {
              notifier.onTerminateUploadProcess(uploadProcesses[index].id);
            },
          ),
        );
      },
    );
  }

  Widget _downloadList() {
    return Consumer(
      builder: (context, ref, child) {
        final downloadProcesses = ref.watch(
          mediaTransferStateNotifierProvider
              .select((value) => value.downloadProcesses),
        );

        if (downloadProcesses.isEmpty) {
          return PlaceHolderScreen(
            title: context.l10n.empty_download_title,
            message: context.l10n.empty_download_message,
            icon: SvgPicture.asset(
              Assets.images.ilDownload,
              height: 200,
              width: 200,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: downloadProcesses.length,
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
          itemBuilder: (context, index) => DownloadProcessItem(
            key: ValueKey(downloadProcesses[index].id),
            process: downloadProcesses[index],
            onCancelTap: () {
              notifier.onTerminateDownloadProcess(downloadProcesses[index].id);
            },
            onRemoveTap: () {
              notifier.onRemoveDownloadProcess(downloadProcesses[index].id);
            },
          ),
        );
      },
    );
  }
}
