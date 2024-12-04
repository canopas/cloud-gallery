import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:data/models/dropbox/token/dropbox_token.dart';
import 'package:data/models/isolate/isolate_parameters.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _providerLocks = <AppMediaImageProvider, Completer<ui.Codec>>{};

/// An [ImageProvider] that loads an [AppMedia] thumbnails.
class AppMediaImageProvider extends ImageProvider<AppMediaImageProvider> {
  final AppMedia media;
  final Size thumbnailSize;

  const AppMediaImageProvider({
    required this.media,
    this.thumbnailSize = const Size(500, 500),
  });

  @override
  ImageStreamCompleter loadImage(
    AppMediaImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: '${key.media.runtimeType}-'
          '${key.media.id}-'
          '${key.media.thumbnailLink ?? ''}-'
          '${key.media.dropboxMediaRefId ?? ''}-'
          '${key.media.sources.map((e) => e.value).join()}-'
          '${key.thumbnailSize}',
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image Provider', this),
          DiagnosticsProperty<AppMediaImageProvider>('Image Key', key),
        ];
      },
    );
  }

  @override
  Future<AppMediaImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AppMediaImageProvider>(this);
  }

  Future<ui.Codec> _loadAsync(
    AppMediaImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    if (_providerLocks.containsKey(key)) {
      return _providerLocks[key]!.future;
    }
    final lock = Completer<ui.Codec>();
    _providerLocks[key] = lock;
    Future(() async {
      try {
        if (media.sources.contains(AppMediaSource.local)) {
          final Uint8List? bytes =
              await media.loadThumbnail(size: thumbnailSize);
          final buffer = await ui.ImmutableBuffer.fromUint8List(bytes!);
          return decode(buffer);
        } else if (media.thumbnailLink != null &&
            media.thumbnailLink?.isNotEmpty == true) {
          final bytes = await compute(
            _loadNetworkImageInBackground,
            IsolateParameters<String>(data: media.thumbnailLink!),
          );
          final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
          return decode(buffer);
        } else if (media.sources.contains(AppMediaSource.dropbox) &&
            media.dropboxMediaRefId != null) {
          final bytes = await compute(
            _loadDropboxThumbnail,
            IsolateParameters<List<String>>(
              data: [media.dropboxMediaRefId!, _getDropboxThumbnailSize()],
            ),
          );
          final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
          return decode(buffer);
        }
        throw NetworkImageLoadException(
          statusCode: 400,
          uri: Uri.parse(''),
        );
      } catch (e) {
        Future<void>.microtask(
          () => PaintingBinding.instance.imageCache.evict(key),
        );
        rethrow;
      }
    }).then((codec) {
      lock.complete(codec);
    }).catchError((e, s) {
      lock.completeError(e, s);
    }).whenComplete(() {
      _providerLocks.remove(key);
    });
    return lock.future;
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

  /// Returns the Dropbox thumbnail size based on the [thumbnailSize].
  String _getDropboxThumbnailSize() {
    switch (thumbnailSize.width) {
      case < 128:
        return 'w128h128';
      case < 256:
        return 'w256h256';
      case < 480:
        return 'w480h320';
      case < 640:
        return 'w640h480';
      case < 960:
        return 'w960h640';
      case < 1024:
        return 'w1024h768';
      case < 2048:
        return 'w2048h1536';
      default:
        return 'w256h256';
    }
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
    final preferences = await SharedPreferences.getInstance();
    final dropboxTokenJson = preferences.getString('dropbox_token');
    final dropboxToken = DropboxToken.fromJson(jsonDecode(dropboxTokenJson!));

    request.headers.add(
      'Authorization',
      'Bearer ${dropboxToken.access_token}',
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
            other.media.dropboxMediaRefId == media.dropboxMediaRefId &&
            other.media.thumbnailLink == media.thumbnailLink &&
            other.media.path == media.path &&
            other.thumbnailSize == thumbnailSize);
  }

  @override
  int get hashCode => media.path.hashCode ^ thumbnailSize.hashCode
      ^ media.thumbnailLink.hashCode ^ media.dropboxMediaRefId.hashCode;
}
