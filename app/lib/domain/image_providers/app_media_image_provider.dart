import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:data/models/isolate/isolate_parameters.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// A custom ImageProvider for fetching [AppMedia] images with caching in local storage.
class AppMediaImageProvider extends ImageProvider<AppMediaImageProvider> {
  /// The [AppMedia] object to fetch the image from.
  final AppMedia media;

  /// The size of the thumbnail to be fetched. Defaults to 500x500.
  final Size thumbnailSize;

  /// The scale of the image. Defaults to 1.
  final double scale;

  /// A debug label for the image.
  final String? debugLabel;

  /// The Dropbox access token for fetching Dropbox images. Required if the media is from Dropbox.
  final String? dropboxAccessToken;

  const AppMediaImageProvider({
    required this.media,
    this.scale = 1,
    this.thumbnailSize = const Size(500, 500),
    this.debugLabel,
    this.dropboxAccessToken,
  });

  @override
  ImageStreamCompleter loadImage(
    AppMediaImageProvider key,
    ImageDecoderCallback decode,
  ) =>
      MultiFrameImageStreamCompleter(
        codec: _loadAsync(key, decode),
        scale: scale,
        debugLabel: debugLabel ?? 'AppMediaImageProvider: ${media.id}',
      );

  @override
  Future<AppMediaImageProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<AppMediaImageProvider>(this);

  Future<ui.Codec> _loadAsync(
    AppMediaImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    // Get cached file directory.
    final directory = await getApplicationDocumentsDirectory();
    final cacheFilePath = '${directory.path}/thumbnail_${media.id}';
    final cacheFile = File(cacheFilePath);

    if (await cacheFile.exists()) {
      // Decode cached file if it exist and return it.
      return await decode(
        await ui.ImmutableBuffer.fromUint8List(
          await cacheFile.readAsBytes(),
        ),
      );
    } else {
      if (media.sources.contains(AppMediaSource.local)) {
        // If the media is local, generate thumbnail from the local asset and cache it.
        final Uint8List? bytes = await media.loadThumbnail(size: thumbnailSize);
        if (bytes != null) {
          await cacheFile.writeAsBytes(bytes);
          return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
        }
        throw Exception('Unable to load thumbnail from local: ${media.id}');
      } else if (media.thumbnailLink != null &&
          media.thumbnailLink?.isNotEmpty == true) {
        // If the media is from network, fetch the image from the network and cache it.
        final Uint8List bytes = await compute(
          _loadNetworkImageInBackground,
          IsolateParameters<String>(data: media.thumbnailLink!),
        );
        await cacheFile.writeAsBytes(bytes);
        return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
      } else if (media.dropboxMediaRefId != null) {
        // If the media is from Dropbox, fetch the image from Dropbox API and cache it.
        final Uint8List bytes = await compute(
          _loadDropboxThumbnail,
          IsolateParameters<List<String>>(
            data: [media.dropboxMediaRefId!, _getDropboxThumbnailSize()],
          ),
        );
        await cacheFile.writeAsBytes(bytes);
        return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
      }
      throw Exception('No image source found for media: ${media.id}');
    }
  }

  /// Loads the network image in the background.
  Future<Uint8List> _loadNetworkImageInBackground(
    IsolateParameters<String> parameters,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
      parameters.rootIsolateToken!,
    );

    final Uri resolved = Uri.base.resolve(parameters.data);
    final HttpClientRequest request = await HttpClient().getUrl(resolved);
    final HttpClientResponse response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      final Uint8List bytes =
          await consolidateHttpClientResponseBytes(response);
      return bytes;
    }
    throw NetworkImageLoadException(
      statusCode: response.statusCode,
      uri: resolved,
    );
  }

  /// Returns a thumbnail size string for Dropbox API based on [thumbnailSize].
  String _getDropboxThumbnailSize() {
    if (thumbnailSize.width < 128) return 'w128h128';
    if (thumbnailSize.width < 256) return 'w256h256';
    if (thumbnailSize.width < 480) return 'w480h320';
    if (thumbnailSize.width < 640) return 'w640h480';
    if (thumbnailSize.width < 960) return 'w960h640';
    if (thumbnailSize.width < 1024) return 'w1024h768';
    if (thumbnailSize.width < 2048) return 'w2048h1536';
    return 'w256h256';
  }

  /// Loads the Dropbox thumbnail in the background.
  Future<Uint8List> _loadDropboxThumbnail(
    IsolateParameters<List<String>> parameters,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
      parameters.rootIsolateToken!,
    );

    final Uri resolved = Uri.base
        .resolve("https://content.dropboxapi.com/2/files/get_thumbnail_v2");

    final HttpClientRequest request = await HttpClient().postUrl(resolved);

    request.headers.add(
      'Authorization',
      'Bearer $dropboxAccessToken',
    );
    request.headers.add(
      'Dropbox-API-Arg',
      jsonEncode({
        "format": "png",
        "mode": "bestfit",
        "quality": "quality_80",
        "resource": {
          ".tag": "path",
          "path": parameters.data.first,
        },
        "size": parameters.data.last,
      }),
    );

    final HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      final Uint8List bytes =
          await consolidateHttpClientResponseBytes(response);
      return bytes;
    }
    throw NetworkImageLoadException(
      statusCode: response.statusCode,
      uri: resolved,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppMediaImageProvider &&
            other.media.id == media.id &&
            other.media.thumbnailLink == media.thumbnailLink &&
            other.media.dropboxMediaRefId == media.dropboxMediaRefId &&
            other.media.sources == media.sources &&
            other.thumbnailSize == thumbnailSize);
  }

  @override
  int get hashCode => Object.hash(
        media.id,
        media.thumbnailLink,
        media.dropboxMediaRefId,
        media.sources,
        thumbnailSize,
      );
}
