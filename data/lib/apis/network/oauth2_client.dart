import 'package:flutter/services.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

const String dropboxAppKey = '873x7j2iwh8mrea';
const String dropboxAppSecret = 'mq2azqdd6y1upzr';
final redirectUri = Uri.parse('https://cloudgallery.com/auth');

void startDropboxSignIn() async {
  final grant = oauth2.AuthorizationCodeGrant(
    dropboxAppKey,
    Uri.parse('https://www.dropbox.com/oauth2/authorize'),
    Uri.parse('https://api.dropboxapi.com/oauth2/token'),
    secret: dropboxAppSecret,
  );

  final authorizationUrl = grant.getAuthorizationUrl(redirectUri);


  if (await canLaunchUrl(authorizationUrl)) {
    await launchUrl(authorizationUrl);
  } else {
    throw PlatformException(code: 'Failed to launch URL');
  }
}

