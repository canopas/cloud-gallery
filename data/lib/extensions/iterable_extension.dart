extension IterableExtension<T> on Iterable<T> {
  Iterable<T> updateWhere(
      {required bool Function(T element) where,
        required T Function(T element) update}) {
    return map((element) => where(element) ? update(element) : element).toList();
  }
}