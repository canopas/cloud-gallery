import 'package:data/errors/l10n_error_codes.dart';

class AppError implements Exception {
  final String? message;
  final String? l10nCode;
  final String? statusCode;

  const AppError({this.message, this.statusCode, this.l10nCode});

  @override
  String toString() {
    return '$runtimeType{message: $message, code: $statusCode, l10nCode: $l10nCode}';
  }
}

class NoConnectionError extends AppError {
  const NoConnectionError()
      : super(
            l10nCode: AppErrorL10nCodes.noInternetConnection,
            message:
                "No internet connection. Please check your network and try again.");
}

class SomethingWentWrongError extends AppError {
  const SomethingWentWrongError({String? message, String? statusCode})
      : super(
            l10nCode: AppErrorL10nCodes.somethingWentWrongError,
            message: message,
            statusCode: statusCode);
}
