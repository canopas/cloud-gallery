import 'package:flutter/cupertino.dart';

class RowBuilder {
  static Row separated({
    required int itemCount,
    required Widget Function(int index) itemBuilder,
    required Widget Function(int index) separatorBuilder,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  }) =>
      Row(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        children: List.generate(
          ((itemCount * 2) - 1) < 0 ? 0 : (itemCount * 2) - 1,
          (index) => index.isEven
              ? itemBuilder(index ~/ 2)
              : separatorBuilder(index ~/ 2),
        ),
      );
}
