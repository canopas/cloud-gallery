import 'package:flutter/cupertino.dart';

class SliverStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget header;
  @override
  final double minExtent;
  @override
  final double maxExtent;

  const SliverStickyHeaderDelegate({
    required this.header,
    this.minExtent = 45,
    this.maxExtent = 45,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      SizedBox.expand(child: header);

  @override
  bool shouldRebuild(SliverStickyHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent ||
      oldDelegate.minExtent != minExtent ||
      oldDelegate.header != header;
}
