import '../../domain/config.dart';
import '../network/urls.dart';
import '../network/endpoint.dart';

class DropboxTokenEndpoint extends Endpoint {
  final String code;
  final String codeVerifier;
  final String clientId;
  final String redirectUrl;
  final String clientSecret;

  const DropboxTokenEndpoint({
    required this.redirectUrl,
    required this.code,
    required this.codeVerifier,
    required this.clientId,
    required this.clientSecret,
  });

  @override
  String get baseUrl => BaseURL.dropboxOAuth2Api;

  @override
  String get path => '/token';

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String? get contentType => 'application/x-www-form-urlencoded';

  @override
  Map<String, String> get data => {
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUrl,
        'code_verifier': codeVerifier,
        'client_id': clientId,
        'client_secret': clientSecret,
      };
}

class DropboxRefreshTokenEndpoint extends Endpoint {
  final String refreshToken;
  final String clientId;
  final String clientSecret;

  const DropboxRefreshTokenEndpoint({
    required this.refreshToken,
    required this.clientId,
    required this.clientSecret,
  });

  @override
  String get baseUrl => BaseURL.dropboxOAuth2Api;

  @override
  String get path => '/token';

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String? get contentType => 'application/x-www-form-urlencoded';

  @override
  Map<String, String> get data => {
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
        'client_id': clientId,
        'client_secret': clientSecret,
      };
}

class DropboxGetUserAccountEndpoint extends Endpoint {
  const DropboxGetUserAccountEndpoint();

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/users/get_current_account';
}

class DropboxCreateAppPropertyTemplate extends Endpoint {
  const DropboxCreateAppPropertyTemplate();

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/file_properties/templates/add_for_user';

  @override
  Map<String, dynamic> get data => {
        "description": "This property is used to store file local information.",
        "fields": [
          {
            "description": "The local reference id of the file.",
            "name": ProviderConstants.localRefIdKey,
            "type": "string",
          }
        ],
        "name": ProviderConstants.dropboxAppTemplateName,
      };
}

class DropboxGetAppPropertyTemplate extends Endpoint {
  const DropboxGetAppPropertyTemplate();

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/file_properties/templates/list_for_user';
}

class DropboxRemoveAppPropertyTemplate extends Endpoint {
  final String id;

  const DropboxRemoveAppPropertyTemplate(this.id);

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/file_properties/templates/remove_for_user';

  @override
  Object? get data => {
        "template_id": id,
      };
}

class DropboxGetAppPropertiesTemplateDetails extends Endpoint {
  final String id;

  const DropboxGetAppPropertiesTemplateDetails(this.id);

  @override
  String get baseUrl => BaseURL.dropboxV2;

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  String get path => '/file_properties/templates/get_for_user';

  @override
  Object? get data => {
        "template_id": id,
      };
}
