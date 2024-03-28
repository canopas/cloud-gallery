extension MapExtension<K, E> on Map<K, List<E>> {
  List<E> valuesWhere(bool Function(E element) test) =>
      values.expand((element) => element.where(test)).toList();
}
