import 'dart:io';
import 'package:data/errors/l10n_error_codes.dart';
import 'package:dio/dio.dart' show DioException, DioExceptionType;

class AppError implements Exception {
  final String? message;
  final String? l10nCode;
  final int? statusCode;

  const AppError({this.message, this.statusCode, this.l10nCode});

  @override
  String toString() {
    return '$runtimeType{message: $message, code: $statusCode, l10nCode: $l10nCode}';
  }

  factory AppError.fromError(Object error) {
    if (error is AppError) {
      return error;
    } else if (error is SocketException) {
      return const NoConnectionError();
    } else if (error is DioException) {
      if (error.type == DioExceptionType.cancel) {
        return const RequestCancelledByUser();
      }
      return SomethingWentWrongError(
        message: error.message,
        statusCode: error.response?.statusCode,
      );
    } else {
      return const SomethingWentWrongError();
    }
  }
}

class NoConnectionError extends AppError {
  const NoConnectionError()
      : super(
            l10nCode: AppErrorL10nCodes.noInternetConnectionError,
            message:
                "No internet connection. Please check your network and try again.");
}

class UserGoogleSignInAccountNotFound extends AppError {
  const UserGoogleSignInAccountNotFound()
      : super(
            l10nCode: AppErrorL10nCodes.googleSignInUserNotFoundError,
            message:
                "User google signed in account not found. Please sign in again");
}

class RequestCancelledByUser extends AppError {
  const RequestCancelledByUser()
      : super(
          message: "Request cancelled.",
        );
}

class BackUpFolderNotFound extends AppError {
  const BackUpFolderNotFound()
      : super(
          l10nCode: AppErrorL10nCodes.backUpFolderNotFoundError,
          message: "Back up folder not found",
          statusCode: 404,
        );
}

class UnableToSaveFileInGallery extends AppError {
  const UnableToSaveFileInGallery()
      : super(
          l10nCode: AppErrorL10nCodes.unableToSaveFileInGalleryError,
          message: "Unable to save file in gallery",
        );
}

class SomethingWentWrongError extends AppError {
  const SomethingWentWrongError({String? message, int? statusCode})
      : super(
          l10nCode: AppErrorL10nCodes.somethingWentWrongError,
          message: message,
          statusCode: statusCode,
        );
}

class AuthSessionExpiredError extends AppError {
  const AuthSessionExpiredError()
      : super(
          l10nCode: AppErrorL10nCodes.authSessionExpiredError,
          message:
              "User authentication session expired. Unable to get access token.",
          statusCode: 401,
        );
}
