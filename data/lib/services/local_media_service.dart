import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import '../domain/config.dart';
import '../domain/json_converters/date_time_json_converter.dart';
import '../models/album/album.dart';
import '../models/clean_up/clean_up.dart';
import '../models/media/media.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

final localMediaServiceProvider = Provider<LocalMediaService>(
  (ref) => const LocalMediaService(),
);

class LocalMediaService {
  const LocalMediaService();

  // MEDIA ---------------------------------------------------------------------

  Future<bool> isLocalFileExist({
    required AppMediaType type,
    required String id,
  }) async {
    return await AssetEntity(id: id, typeInt: type.index, width: 0, height: 0)
        .isLocallyAvailable();
  }

  Future<bool> requestPermission() async {
    final state = await PhotoManager.requestPermissionExtend();
    return state.hasAccess;
  }

  Future<int> getMediaCount() async {
    return await PhotoManager.getAssetCount(
      filterOption: FilterOptionGroup(
        orders: [const OrderOption(type: OrderOptionType.createDate)],
      ),
    );
  }

  Future<List<AppMedia>> getAllLocalMedia() async {
    final count = await PhotoManager.getAssetCount();
    final assets = await PhotoManager.getAssetListRange(
      start: 0,
      end: count,
      filterOption: FilterOptionGroup(
        orders: [const OrderOption(type: OrderOptionType.createDate)],
      ),
    );
    final files = await Future.wait(
      assets.map(
        (asset) => AppMedia.fromAssetEntity(asset),
      ),
    );
    return files.nonNulls.toList();
  }

  Future<List<AppMedia>> getLocalMedia({
    required int start,
    required int end,
  }) async {
    final assets = await PhotoManager.getAssetListRange(
      start: start,
      end: end,
      filterOption: FilterOptionGroup(
        orders: [const OrderOption(type: OrderOptionType.createDate)],
      ),
    );
    final files = await Future.wait(
      assets.map(
        (asset) => AppMedia.fromAssetEntity(asset),
      ),
    );
    return files.nonNulls.toList();
  }

  Future<AppMedia?> getMedia({required String id}) async {
    final asset = await AssetEntity.fromId(id);
    if (asset == null) return null;
    return AppMedia.fromAssetEntity(asset);
  }

  Future<List<String>> deleteMedias(List<String> medias) async {
    return await PhotoManager.editor.deleteWithIds(medias);
  }

  Future<AppMedia?> saveInGallery({
    required String saveFromLocation,
    required AppMediaType type,
  }) async {
    AssetEntity? asset;
    if (type.isVideo) {
      asset = await PhotoManager.editor.saveVideo(
        File(saveFromLocation),
        title: saveFromLocation.split('/').last,
      );
    } else if (type.isImage) {
      asset = await PhotoManager.editor.saveImageWithPath(
        saveFromLocation,
        title: saveFromLocation.split('/').last,
      );
    }
    return asset != null ? AppMedia.fromAssetEntity(asset) : null;
  }

  // CLEAN UP ------------------------------------------------------------------

  Future<Database> openCleanUpDatabase() async {
    return await openDatabase(
      LocalDatabaseConstants.databaseName,
      version: 1,
      onConfigure: (Database db) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS ${LocalDatabaseConstants.cleanUpTable} ('
              'id TEXT PRIMARY KEY, '
              'provider TEXT NOT NULL, '
              'created_at TEXT NOT NULL, '
              'provider_ref_id TEXT'
              ')',
        );
      },
    );
  }

  Future<void> addToCleanUpMediaDatabase({
    required List<CleanUpMedia> medias,
  }) async {
    final database = await openCleanUpDatabase();
    final batch = database.batch();
    for (CleanUpMedia media in medias) {
      batch.insert(
        LocalDatabaseConstants.cleanUpTable,
        media.toJson(),
      );
    }
    await batch.commit();
  }

  Future<void> removeFromCleanUpMediaDatabase(List<String> ids) async {
    final database = await openCleanUpDatabase();
    await database.delete(
      LocalDatabaseConstants.cleanUpTable,
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }

  Future<void> clearCleanUpMediaDatabase() async {
    final database = await openCleanUpDatabase();
    await database.delete(LocalDatabaseConstants.cleanUpTable);
  }

  Future<List<CleanUpMedia>> getCleanUpMedias() async {
    final database = await openCleanUpDatabase();
    final res = await database.query(LocalDatabaseConstants.cleanUpTable);
    return res.map((e) => CleanUpMedia.fromJson(e)).toList();
  }

  // ALBUM ---------------------------------------------------------------------

  Future<Database> openAlbumDatabase() async {
    return await openDatabase(
      LocalDatabaseConstants.albumDatabaseName,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE ${LocalDatabaseConstants.albumsTable} ('
          'id TEXT PRIMARY KEY, '
          'name TEXT NOT NULL, '
          'source TEXT NOT NULL, '
          'created_at TEXT NOT NULL, '
          'medias TEXT NOT NULL '
          ')',
        );
      },
    );
  }

  Future<void> createAlbum({required String id, required String name}) async {
    final db = await openAlbumDatabase();
    await db.insert(
      LocalDatabaseConstants.albumsTable,
      {
        'id': id,
        'name': name,
        'source': AppMediaSource.local.value,
        'created_at': DateTimeJsonConverter().toJson(DateTime.now()),
        'medias': '',
      },
    );
    await db.close();
  }

  Future<void> updateAlbum(Album album) async {
    final db = await openAlbumDatabase();
    await db.rawUpdate(
      'UPDATE ${LocalDatabaseConstants.albumsTable} SET '
      'name = ?, '
      'medias = ? '
      'WHERE id = ?',
      [
        album.name,
        album.medias.join(','),
        album.id,
      ],
    );
    await db.close();
  }

  Future<void> deleteAlbum(String id) async {
    final db = await openAlbumDatabase();
    await db.delete(
      LocalDatabaseConstants.albumsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    await db.close();
  }

  Future<List<Album>> getAlbums() async {
    final db = await openAlbumDatabase();
    final albums = await db.query(LocalDatabaseConstants.albumsTable);
    await db.close();
    return albums
        .map(
          (album) => Album(
            id: album['id'] as String,
            name: album['name'] as String,
            source: AppMediaSource.values.firstWhere(
              (source) => source.value == album['source'],
            ),
            created_at:
                DateTimeJsonConverter().fromJson(album['created_at'] as String),
            medias: (album['medias'] as String).trim().isEmpty
                ? []
                : (album['medias'] as String).trim().split(','),
          ),
        )
        .toList();
  }
}
