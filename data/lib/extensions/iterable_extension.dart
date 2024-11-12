extension ListExtension<E> on List<E> {
  void updateWhere(
      {required bool Function(E element) where,
      required E Function(E element) update}) {
    for (var i = 0; i < length; i++) {
      if (where(elementAt(i))) {
        this[i] = update(elementAt(i));
      }
    }
  }
}
