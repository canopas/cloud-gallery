import 'dart:ui' show RootIsolateToken;

class IsolateParameters<T> {
  final T data;
  final RootIsolateToken? rootIsolateToken;

  IsolateParameters({required this.data, RootIsolateToken? token})
      : rootIsolateToken = token ?? RootIsolateToken.instance;
}
