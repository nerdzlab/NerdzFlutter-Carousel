import 'package:flutter/material.dart';

class IndicatorStyle {
  const IndicatorStyle({
    this.unselectedColor = Colors.grey,
    this.selectedColor = Colors.blue,
    this.size = const Size(12, 12),
    this.unselectedSize = const Size(12, 12),
    this.duration = const Duration(milliseconds: 150),
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.alignment = Alignment.center,
    this.fadeEdges = true,
    this.boxShape = BoxShape.circle,
    this.indicatorPadding = 16,
    this.borderRadius,
    this.onItemClicked,
  }) : assert(
          boxShape != BoxShape.circle || borderRadius == null,
          'Border radius must be provided when using a non-circle shape',
        );

  /// The color applied to the dot when the dots' indexes are different from
  /// currentItem.
  final Color unselectedColor;

  /// The color applied to the dot when the dots' index is the same as
  /// currentItem.
  final Color selectedColor;

  /// The size of the dot corresponding to the currentItem or the default
  /// size of the dots when [unselectedSize] is null.
  final Size size;

  /// The size of the dots when the currentItem is different from the dots'
  /// indexes.
  final Size unselectedSize;

  /// The duration of the animations used by the dots when the currentItem is
  /// changed
  final Duration duration;

  /// The margin between the dots.
  final EdgeInsets margin;

  /// The external padding.
  final EdgeInsets padding;

  /// The alignment of the dots regarding the whole container.
  final Alignment alignment;

  /// If the edges should be faded or not.
  final bool fadeEdges;

  /// The shape of the indicators.
  final BoxShape boxShape;

  /// Border radius of the indicators.
  final BorderRadius? borderRadius;

  /// Padding between Indicator and PageView.
  final double indicatorPadding;

  /// Callback called when item is clicked.
  final void Function(int index)? onItemClicked;
}
