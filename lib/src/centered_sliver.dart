import 'dart:ui';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A sliver that contains multiple box children that each fills the viewport.
///
/// _To learn more about slivers, see [CustomScrollView.slivers]._
///
/// [SliverFillViewportCentered] places its children in a linear array along the main
/// axis. Each child is sized to fill the viewport, both in the main and cross
/// axis.
///
/// See also:
///
///  * [SliverFixedExtentList], which has a configurable
///    [SliverFixedExtentList.itemExtent].
///  * [SliverPrototypeExtentList], which is similar to [SliverFixedExtentList]
///    except that it uses a prototype list item instead of a pixel value to define
///    the main axis extent of each item.
///  * [SliverList], which does not require its children to have the same
///    extent in the main axis.
class SliverFillViewportCentered extends StatelessWidget {
  /// Creates a sliver whose box children that each fill the viewport.
  const SliverFillViewportCentered({
    super.key,
    required this.delegate,
    this.viewportFraction = 1.0,
  }) : assert(viewportFraction > 0.0);

  /// The fraction of the viewport that each child should fill in the main axis.
  ///
  /// If this fraction is less than 1.0, more than one child will be visible at
  /// once. If this fraction is greater than 1.0, each child will be larger than
  /// the viewport in the main axis.
  final double viewportFraction;

  /// {@macro flutter.widgets.SliverMultiBoxAdaptorWidget.delegate}
  final SliverChildDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return _SliverFractionalPaddingCentered(
      elementCount: delegate.estimatedChildCount ?? 0,
      viewportFraction: clampDouble(1 - viewportFraction, 0, 1) / 2,
      sliver: _SliverFillViewportCenteredRenderObjectWidget(
        viewportFraction: viewportFraction,
        delegate: delegate,
      ),
    );
  }
}

class _SliverFillViewportCenteredRenderObjectWidget
    extends SliverMultiBoxAdaptorWidget {
  const _SliverFillViewportCenteredRenderObjectWidget({
    required super.delegate,
    this.viewportFraction = 1.0,
  }) : assert(viewportFraction > 0.0);

  final double viewportFraction;

  @override
  RenderSliverFillViewport createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderSliverFillViewport(
        childManager: element, viewportFraction: viewportFraction);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverFillViewport renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _SliverFractionalPaddingCentered extends SingleChildRenderObjectWidget {
  const _SliverFractionalPaddingCentered({
    required this.elementCount,
    this.viewportFraction = 0,
    Widget? sliver,
  })  : assert(viewportFraction >= 0),
        assert(viewportFraction <= 0.5),
        super(child: sliver);

  final double viewportFraction;
  final int elementCount;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderCenteredSliverFractionalPadding(
          elementCount: elementCount, viewportFraction: viewportFraction);

  @override
  void updateRenderObject(BuildContext context,
      _RenderCenteredSliverFractionalPadding renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _RenderCenteredSliverFractionalPadding
    extends RenderSliverEdgeInsetsPadding {
  _RenderCenteredSliverFractionalPadding({
    required this.elementCount,
    double viewportFraction = 0,
  })  : assert(viewportFraction <= 0.5),
        assert(viewportFraction >= 0),
        _viewportFraction = viewportFraction;

  SliverConstraints? _lastResolvedConstraints;
  final int elementCount;

  double get viewportFraction => _viewportFraction;
  double _viewportFraction;
  set viewportFraction(double newValue) {
    if (_viewportFraction == newValue) {
      return;
    }
    _viewportFraction = newValue;
    _markNeedsResolution();
  }

  @override
  EdgeInsets? get resolvedPadding => _resolvedPadding;
  EdgeInsets? _resolvedPadding;

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  void _resolve() {
    if (_resolvedPadding != null && _lastResolvedConstraints == constraints) {
      return;
    }

    final double cleanPadding =
        constraints.viewportMainAxisExtent * viewportFraction;
    final double elementSize =
        (constraints.viewportMainAxisExtent - cleanPadding * 2);
    final double maxOffset =
        elementSize * (elementCount - 1) - cleanPadding * 2;
    final double paddingValue = cleanPadding -
        // Left
        (cleanPadding -
            math.min(math.max(constraints.scrollOffset, 0), cleanPadding)) -
        //Right
        (cleanPadding -
            math.max(
                math.min(maxOffset - constraints.scrollOffset, cleanPadding),
                0));

    _lastResolvedConstraints = constraints;
    _resolvedPadding = switch (constraints.axis) {
      Axis.horizontal => EdgeInsets.symmetric(horizontal: paddingValue),
      Axis.vertical => EdgeInsets.symmetric(vertical: paddingValue),
    };

    return;
  }

  @override
  void performLayout() {
    _resolve();
    super.performLayout();
  }
}
