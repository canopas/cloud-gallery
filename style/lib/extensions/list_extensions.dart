extension ListExtension<E> on List<E> {
  void addIfNotExist(List<E> list) {
    for (E element in list) {
      if (!contains(element)) {
        add(element);
      }
    }
  }

  /// Replaces [oldElement] with [newElement] if found, else adds [newElement].
  void updateElement({
    required E newElement,
    required E oldElement,
    bool addIfNotContain = false,
  }) {
    if (contains(oldElement)) {
      this[indexOf(oldElement)] = newElement;
    } else if (addIfNotContain) {
      add(newElement);
    }
  }

  void addOrRemove({required E element}) {
    if (contains(element)) {
      remove(element);
    } else {
      add(element);
    }
  }
}
