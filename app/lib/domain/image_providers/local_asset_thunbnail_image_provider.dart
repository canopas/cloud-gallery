import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

/// A custom ImageProvider for create thumbnail of local asset and caching in local storage.
class LocalAssetCachedThumbnailImageProvider
    extends ImageProvider<LocalAssetCachedThumbnailImageProvider> {
  /// The URL of the image to be fetched.
  final String url;

  const LocalAssetCachedThumbnailImageProvider({
    required this.url,
  });

  @override
  Future<LocalAssetCachedThumbnailImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) =>
      SynchronousFuture<LocalAssetCachedThumbnailImageProvider>(this);

  @override
  ImageStreamCompleter loadImage(
    LocalAssetCachedThumbnailImageProvider key,
    ImageDecoderCallback decode,
  ) =>
      OneFrameImageStreamCompleter(_loadAsync(key, decode));

  Future<ImageInfo> _loadAsync(
    LocalAssetCachedThumbnailImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    // Get the cached file if it exists, otherwise fetch it from the network
    final directory = await getApplicationDocumentsDirectory();
    final cacheFilePath = '${directory.path}/network_image_$url';
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

      // Fetch the image from the network
      final response = await Dio().get(url);

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
            url,
          ),
        );
      }
    }
  }

  /// Clears the cached images from local storage.
  static Future<void> clearCache() async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDirectory = Directory(directory.path);

    if (await cacheDirectory.exists()) {
      final files = cacheDirectory.listSync().where(
            (file) => file is File && file.path.contains('network_image_'),
          );
      for (var file in files) {
        await file.delete();
      }
    }
  }

  @override
  bool operator ==(Object other) {
    return other is LocalAssetCachedThumbnailImageProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;
}
