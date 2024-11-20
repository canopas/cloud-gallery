import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class ApiDropboxEntitie with _$ApiDropboxEntitie {
  const factory ApiDropboxEntities({
    required String id,
    required String name,
    required String path_lower,
    required String path_desplay,
  }) = _ApiDropboxEntities;
}
