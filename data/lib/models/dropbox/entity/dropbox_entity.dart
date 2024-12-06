// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dropbox_entity.freezed.dart';

part 'dropbox_entity.g.dart';

@freezed
class ApiDropboxEntity with _$ApiDropboxEntity {
  const factory ApiDropboxEntity({
    required String id,
    required String name,
    required String path_lower,
    required String path_display,
    @JsonKey(
      name: '.tag',
      unknownEnumValue: ApiDropboxEntityType.unknown,
    )
    required ApiDropboxEntityType type,
  }) = _ApiDropboxEntity;

  factory ApiDropboxEntity.fromJson(Map<String, dynamic> json) =>
      _$ApiDropboxEntityFromJson(json);

  factory ApiDropboxEntity.fromFolderJson(Map<String, dynamic> json) {
    json.addAll({".tag": "folder"});
    return _$ApiDropboxEntityFromJson(json);
  }
}

@JsonEnum(valueField: "value")
enum ApiDropboxEntityType {
  folder('folder'),
  unknown('unknown');

  final String value;

  const ApiDropboxEntityType(this.value);
}
