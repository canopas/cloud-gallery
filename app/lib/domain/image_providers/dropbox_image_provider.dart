import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

/// A custom ImageProvider for fetching Dropbox thumbnails with caching it in local storage.
class DropboxThumbnailProvider extends ImageProvider<DropboxThumbnailProvider> {
  /// The ID of the Dropbox file whose thumbnail is to be fetched.
  final String id;

  /// The size of the thumbnail to be fetched. Defaults to 200.
  final double size;

  /// The access token for Dropbox API authorization.
  final String accessToken;

  const DropboxThumbnailProvider({
    required this.id,
    required this.accessToken,
    this.size = 200,
  });

  @override
  Future<DropboxThumbnailProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<DropboxThumbnailProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    DropboxThumbnailProvider key,
    ImageDecoderCallback decode,
  ) =>
      OneFrameImageStreamCompleter(_loadAsync(key, decode));

  Future<ImageInfo> _loadAsync(
    DropboxThumbnailProvider key,
    ImageDecoderCallback decode,
  ) async {
    // Get the cached file if it exists, otherwise fetch it from Dropbox API
    final directory = await getApplicationDocumentsDirectory();
    final cacheFilePath = '${directory.path}/dropbox_thumbnail_$id';
    final cacheFile = File(cacheFilePath);

    if (await cacheFile.exists()) {
      // Decode existing file in the cache
      final codec = await decode(
        await ui.ImmutableBuffer.fromUint8List(
          await cacheFile.readAsBytes(),
        ),
      );

      // Return first frame of the image and release the image resources
      final frame = await codec.getNextFrame();
      codec.dispose();
      return ImageInfo(image: frame.image);
    } else {
      // Create the cache file if it doesn't exist.
      if (Platform.isIOS) {
        await cacheFile.create(recursive: true);
      }

      // Fetch the thumbnail from Dropbox API
      final response = await Dio().post(
        'https://content.dropboxapi.com/2/files/get_thumbnail_v2',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Dropbox-API-Arg': {
              "format": "png",
              "mode": "bestfit",
              "quality": "quality_80",
              "resource": {
                ".tag": "path",
                "path": id,
              },
              "size": _getDropboxThumbnailSize(size),
            },
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        // Write the fetched image to the cache
        await cacheFile.writeAsBytes(response.data);

        // Decode the fetched image and return the first frame
        final codec =
            await decode(await ui.ImmutableBuffer.fromUint8List(response.data));
        final frame = await codec.getNextFrame();
        codec.dispose();
        return ImageInfo(image: frame.image);
      } else {
        throw NetworkImageLoadException(
          statusCode: response.statusCode ?? 400,
          uri: Uri.parse(
            'https://content.dropboxapi.com/2/files/get_thumbnail_v2',
          ),
        );
      }
    }
  }

  /// Returns the Dropbox thumbnail size string based on the provided size.
  String _getDropboxThumbnailSize(double size) {
    if (size < 128) return 'w128h128';
    if (size < 256) return 'w256h256';
    if (size < 480) return 'w480h320';
    if (size < 640) return 'w640h480';
    if (size < 960) return 'w960h640';
    if (size < 1024) return 'w1024h768';
    if (size < 2048) return 'w2048h1536';
    return 'w256h256';
  }

  /// Clears the cached thumbnails from local storage.
  static Future<void> clearCache() async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDirectory = Directory(directory.path);

    if (await cacheDirectory.exists()) {
      final files = cacheDirectory.listSync().where(
            (file) => file is File && file.path.contains('dropbox_thumbnail_'),
          );
      for (var file in files) {
        await file.delete();
      }
    }
  }

  @override
  bool operator ==(Object other) {
    return other is DropboxThumbnailProvider &&
        other.id == id &&
        other.accessToken == accessToken &&
        other.size == size;
  }

  @override
  int get hashCode => Object.hash(id, accessToken, size);
}
