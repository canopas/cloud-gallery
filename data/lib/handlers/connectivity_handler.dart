import 'dart:io';

///
Future<void> internetLookUp() async {
     await InternetAddress.lookup('google.com');
}