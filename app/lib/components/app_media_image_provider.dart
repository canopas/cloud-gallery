import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:data/models/isolate/isolate_parameters.dart';
import 'package:data/models/media/media.dart';
import 'package:data/models/media/media_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _providerLocks = <AppMediaImageProvider, Completer<ui.Codec>>{};

class AppMediaImageProvider extends ImageProvider<AppMediaImageProvider> {
  final AppMedia media;
  final Size thumbnailSize;

  const AppMediaImageProvider(
      {required this.media, this.thumbnailSize = const Size(500, 500)});

  @override
  ImageStreamCompleter loadImage(
      AppMediaImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: '${key.media.runtimeType}-'
          '${key.media.id}-'
          '${key.media.thumbnailLink ?? ''}'
          '${key.media.sources.contains(AppMediaSource.local) ? 'local' : 'network'}'
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
          final bytes = await compute(_loadNetworkImageInBackground,
              IsolateParameters<String>(data: media.thumbnailLink!));
          final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
          return decode(buffer);
        }
        throw Exception('No image source found.');
      } catch (e) {
        Future<void>.microtask(
                () => PaintingBinding.instance.imageCache.evict(key));
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

  Future<Uint8List> _loadNetworkImageInBackground(
      IsolateParameters<String> parameters) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(
        parameters.rootIsolateToken!);
    final Uri resolved = Uri.base.resolve(parameters.data);
    final HttpClientRequest request = await HttpClient().getUrl(resolved);
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw NetworkImageLoadException(
          statusCode: response.statusCode, uri: resolved,);
    }
    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    return bytes;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppMediaImageProvider &&
            other.media.path == media.path &&
            other.thumbnailSize == thumbnailSize);
  }

  @override
  int get hashCode => media.hashCode ^ thumbnailSize.hashCode;
}