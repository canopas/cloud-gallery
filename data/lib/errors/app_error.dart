import 'dart:io';
import 'package:flutter/services.dart';
import 'l10n_error_codes.dart';
import 'package:dio/dio.dart' show DioException;

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
    } else if (error is SocketException ||
        (error is PlatformException && error.code == 'network_error')) {
      return const NoConnectionError();
    } else if (error is DioException) {
      if (error.response?.statusCode == 403 &&
          error.requestOptions.uri.host == 'www.googleapis.com') {
        return NoGoogleDriveAccessError();
      }
      return SomethingWentWrongError(
        message: error.message,
        statusCode: error.response?.statusCode,
      );
    }
    return SomethingWentWrongError(message: error.toString());
  }
}

class NoConnectionError extends AppError {
  const NoConnectionError()
      : super(
          l10nCode: AppErrorL10nCodes.noInternetConnectionError,
          message:
              "No internet connection. Please check your network and try again.",
        );
}

class UserGoogleSignInAccountNotFound extends AppError {
  const UserGoogleSignInAccountNotFound()
      : super(
          l10nCode: AppErrorL10nCodes.googleSignInUserNotFoundError,
          message:
              "User google signed in account not found. Please sign in again",
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
  const SomethingWentWrongError({super.message, super.statusCode})
      : super(
          l10nCode: AppErrorL10nCodes.somethingWentWrongError,
        );
}

class NoGoogleDriveAccessError extends AppError {
  const NoGoogleDriveAccessError()
      : super(
          l10nCode: AppErrorL10nCodes.noGoogleDriveAccessError,
          message:
              "It seems we don’t have the required permissions to access your Google Drive. Please sign in again and grant the necessary permissions.",
        );
}

class DropboxAuthSessionExpiredError extends AppError {
  const DropboxAuthSessionExpiredError()
      : super(
          l10nCode: AppErrorL10nCodes.authSessionExpiredError,
          message:
              "User authentication session expired. Unable to get dropbox access token.",
          statusCode: 401,
        );
}
