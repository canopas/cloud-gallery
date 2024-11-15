import 'dart:convert';
import 'dart:math' show Random;
import 'package:crypto/crypto.dart' show sha256;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final oauth2Provider = Provider<Oauth2>((ref) => Oauth2());

class Oauth2 {
  String _generateCodeVerifier({
    String charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~',
  }) =>
      List.generate(
        128,
        (i) => charset[Random.secure().nextInt(charset.length)],
      ).join();

  String get generateCodeVerifier => _generateCodeVerifier();

  Uri getAuthorizationUrl({
    required String clientId,
    required Uri authorizationEndpoint,
    required String redirectUri,
    required String codeVerifier,
    String responseType = 'code',
    List<String> scopes = const [],
    String delimiter = ' ',
    Map<String, String> additionalParameters = const {},
    String? state,
  }) {
    final codeChallenge = base64Url
        .encode(sha256.convert(ascii.encode(codeVerifier)).bytes)
        .replaceAll('=', '');

    final parameters = {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': responseType,
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    };

    if (additionalParameters.isNotEmpty) {
      parameters.addAll(additionalParameters);
    }
    if (state != null) parameters['state'] = state;
    if (scopes.isNotEmpty) parameters['scope'] = scopes.join(delimiter);

    return authorizationEndpoint.replace(
      queryParameters: Map.from(authorizationEndpoint.queryParameters)
        ..addAll(parameters),
    );
  }
}
