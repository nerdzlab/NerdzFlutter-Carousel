import 'package:carousel_nerdzlab/src/centered_sliver.dart';
import 'package:carousel_nerdzlab/src/indicator_style.dart';
import 'package:carousel_nerdzlab/src/page_view_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CenteredPageView extends StatefulWidget {
  /// Creates a scrollable list that works page by page from an explicit [List]
  /// of widgets.
  ///
  /// This constructor is appropriate for page views with a small number of
  /// children because constructing the [List] requires doing work for every
  /// child that could possibly be displayed in the page view, instead of just
  /// those children that are actually visible.
  ///
  /// Like other widgets in the framework, this widget expects that
  /// the [children] list will not be mutated after it has been passed in here.
  /// See the documentation at [SliverChildListDelegate.children] for more details.
  ///
  /// {@template flutter.widgets.PageView.allowImplicitScrolling}
  /// If [allowImplicitScrolling] is true, the [CenteredPageView] will participate in
  /// accessibility scrolling more like a [ListView], where implicit scroll
  /// actions will move to the next page rather than into the contents of the
  /// [CenteredPageView].
  /// {@endtemplate}
  CenteredPageView({
    super.key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    List<Widget> children = const <Widget>[],
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.scrollBehavior,
    this.padEnds = true,
    this.showIndicator = true,
    this.indicatorStyle = const IndicatorStyle(),
  })  : childrenDelegate = SliverChildListDelegate(children),
        assert(children.isNotEmpty, "Children can't be empty");

  /// Creates a scrollable list that works page by page using widgets that are
  /// created on demand.
  ///
  /// This constructor is appropriate for page views with a large (or infinite)
  /// number of children because the builder is called only for those children
  /// that are actually visible.
  ///
  /// Providing a non-null [itemCount] lets the [CenteredPageView] compute the maximum
  /// scroll extent.
  ///
  /// [itemBuilder] will be called only with indices greater than or equal to
  /// zero and less than [itemCount].
  ///
  /// {@macro flutter.widgets.ListView.builder.itemBuilder}
  ///
  /// {@template flutter.widgets.PageView.findChildIndexCallback}
  /// The [findChildIndexCallback] corresponds to the
  /// [SliverChildBuilderDelegate.findChildIndexCallback] property. If null,
  /// a child widget may not map to its existing [RenderObject] when the order
  /// of children returned from the children builder changes.
  /// This may result in state-loss. This callback needs to be implemented if
  /// the order of the children may change at a later time.
  /// {@endtemplate}
  ///
  /// {@macro flutter.widgets.PageView.allowImplicitScrolling}
  CenteredPageView.builder({
    super.key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    required NullableIndexedWidgetBuilder itemBuilder,
    ChildIndexGetter? findChildIndexCallback,
    required int itemCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.scrollBehavior,
    this.padEnds = true,
    this.showIndicator = true,
    this.indicatorStyle = const IndicatorStyle(),
  }) : childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          findChildIndexCallback: findChildIndexCallback,
          childCount: itemCount,
        );

  /// Creates a scrollable list that works page by page with a custom child
  /// model.
  ///
  /// {@tool dartpad}
  /// This example shows a [CenteredPageView] that uses a custom [SliverChildBuilderDelegate] to support child
  /// reordering.
  ///
  /// ** See code in examples/api/lib/widgets/page_view/page_view.1.dart **
  /// {@end-tool}
  ///
  /// {@macro flutter.widgets.PageView.allowImplicitScrolling}
  CenteredPageView.custom({
    super.key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    required this.childrenDelegate,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.scrollBehavior,
    this.padEnds = true,
    this.showIndicator = true,
    this.indicatorStyle = const IndicatorStyle(),
  }) : assert(childrenDelegate.estimatedChildCount != null,
            "Child Count can't be null");

  /// Controls whether the widget's pages will respond to
  /// [RenderObject.showOnScreen], which will allow for implicit accessibility
  /// scrolling.
  ///
  /// With this flag set to false, when accessibility focus reaches the end of
  /// the current page and the user attempts to move it to the next element, the
  /// focus will traverse to the next widget outside of the page view.
  ///
  /// With this flag set to true, when accessibility focus reaches the end of
  /// the current page and user attempts to move it to the next element, focus
  /// will traverse to the next page in the page view.
  final bool allowImplicitScrolling;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// The [Axis] along which the scroll view's offset increases with each page.
  ///
  /// For the direction in which active scrolling may be occurring, see
  /// [ScrollDirection].
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Whether the page view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the page view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the page view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this page
  /// view is scrolled.
  final PageController? controller;

  /// How the page view should respond to user input.
  ///
  /// For example, determines how the page view continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  ///
  /// If the [padEnds] is false and [PageController.viewportFraction] < 1.0,
  /// the page will snap to the beginning of the viewport; otherwise, the page
  /// will snap to the center of the viewport.
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;

  /// A delegate that provides the children for the [CenteredPageView].
  ///
  /// The [PageView.custom] constructor lets you specify this delegate
  /// explicitly. The [CenteredPageView] and [PageView.builder] constructors create a
  /// [childrenDelegate] that wraps the given [List] and [IndexedWidgetBuilder],
  /// respectively.
  final SliverChildDelegate childrenDelegate;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// {@macro flutter.widgets.scrollable.hitTestBehavior}
  ///
  /// Defaults to [HitTestBehavior.opaque].
  final HitTestBehavior hitTestBehavior;

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  ///
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  ///
  /// The [ScrollBehavior] of the inherited [ScrollConfiguration] will be
  /// modified by default to not apply a [Scrollbar].
  final ScrollBehavior? scrollBehavior;

  /// Whether to add padding to both ends of the list.
  ///
  /// If this is set to true and [PageController.viewportFraction] < 1.0, padding will be added
  /// such that the first and last child slivers will be in the center of
  /// the viewport when scrolled all the way to the start or end, respectively.
  ///
  /// If [PageController.viewportFraction] >= 1.0, this property has no effect.
  ///
  /// This property defaults to true.
  final bool padEnds;

  /// Whether show indicator under PageView.
  final bool showIndicator;

  /// Style for dot indicator
  final IndicatorStyle indicatorStyle;

  @override
  State<CenteredPageView> createState() => _CenteredPageViewState();
}

class _CenteredPageViewState extends State<CenteredPageView> {
  int _lastReportedPage = 0;

  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
    _lastReportedPage = _controller.initialPage;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _initController() {
    _controller = widget.controller ?? PageController();
  }

  @override
  void didUpdateWidget(CenteredPageView oldWidget) {
    if (oldWidget.controller != widget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _initController();
    }
    super.didUpdateWidget(oldWidget);
  }

  AxisDirection _getDirection(BuildContext context) {
    switch (widget.scrollDirection) {
      case Axis.horizontal:
        assert(debugCheckHasDirectionality(context));
        final TextDirection textDirection = Directionality.of(context);
        final AxisDirection axisDirection =
            textDirectionToAxisDirection(textDirection);
        return widget.reverse
            ? flipAxisDirection(axisDirection)
            : axisDirection;
      case Axis.vertical:
        return widget.reverse ? AxisDirection.up : AxisDirection.down;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AxisDirection axisDirection = _getDirection(context);
    final ScrollPhysics physics = _CenteredForceImplicitScrollPhysics(
      allowImplicitScrolling: widget.allowImplicitScrolling,
    ).applyTo(
      widget.pageSnapping
          ? _kCenteredPagePhysics.applyTo(widget.physics ??
              widget.scrollBehavior?.getScrollPhysics(context))
          : widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification.depth == 0 &&
                  (widget.onPageChanged != null || widget.showIndicator) &&
                  notification is ScrollUpdateNotification) {
                final PageMetrics metrics = notification.metrics as PageMetrics;
                final int currentPage = metrics.page!.round();
                if (currentPage != _lastReportedPage) {
                  setState(() {
                    _lastReportedPage = currentPage;
                  });
                  widget.onPageChanged?.call(currentPage);
                }
              }
              return false;
            },
            child: Scrollable(
              dragStartBehavior: widget.dragStartBehavior,
              axisDirection: axisDirection,
              controller: _controller,
              physics: physics,
              restorationId: widget.restorationId,
              hitTestBehavior: widget.hitTestBehavior,
              scrollBehavior: widget.scrollBehavior ??
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              viewportBuilder: (BuildContext context, ViewportOffset position) {
                return Viewport(
                  // TODO(dnfield): we should provide a way to set cacheExtent
                  // independent of implicit scrolling:
                  // https://github.com/flutter/flutter/issues/45632
                  cacheExtent: widget.allowImplicitScrolling ? 1.0 : 0.0,
                  cacheExtentStyle: CacheExtentStyle.viewport,
                  axisDirection: axisDirection,
                  offset: position,
                  clipBehavior: widget.clipBehavior,
                  slivers: <Widget>[
                    SliverFillViewportCentered(
                      viewportFraction: _controller.viewportFraction,
                      delegate: widget.childrenDelegate,
                      padEnds: widget.padEnds,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        if (widget.showIndicator)
          Padding(
            padding:
                EdgeInsets.only(top: widget.indicatorStyle.indicatorPadding),
            child: SizedBox(
              width: widget.indicatorStyle.indicatorWidth,
              child: PageViewDotIndicator(
                currentItem: _lastReportedPage,
                count: widget.childrenDelegate.estimatedChildCount!,
                unselectedColor: widget.indicatorStyle.unselectedColor,
                selectedColor: widget.indicatorStyle.selectedColor,
                size: widget.indicatorStyle.size,
                unselectedSize: widget.indicatorStyle.unselectedSize,
                duration: widget.indicatorStyle.duration,
                margin: widget.indicatorStyle.margin,
                padding: widget.indicatorStyle.padding,
                alignment: widget.indicatorStyle.alignment,
                fadeEdges: widget.indicatorStyle.fadeEdges,
                boxShape: widget.indicatorStyle.boxShape,
                borderRadius: widget.indicatorStyle.borderRadius,
                onItemClicked: widget.indicatorStyle.onItemClicked,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description
        .add(EnumProperty<Axis>('scrollDirection', widget.scrollDirection));
    description.add(
        FlagProperty('reverse', value: widget.reverse, ifTrue: 'reversed'));
    description.add(DiagnosticsProperty<PageController>(
        'controller', _controller,
        showName: false));
    description.add(DiagnosticsProperty<ScrollPhysics>(
        'physics', widget.physics,
        showName: false));
    description.add(FlagProperty('pageSnapping',
        value: widget.pageSnapping, ifFalse: 'snapping disabled'));
    description.add(FlagProperty('allowImplicitScrolling',
        value: widget.allowImplicitScrolling,
        ifTrue: 'allow implicit scrolling'));
  }
}

const PageScrollPhysics _kCenteredPagePhysics = PageScrollPhysics();

class _CenteredForceImplicitScrollPhysics extends ScrollPhysics {
  const _CenteredForceImplicitScrollPhysics({
    required this.allowImplicitScrolling,
    super.parent,
  });

  @override
  _CenteredForceImplicitScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _CenteredForceImplicitScrollPhysics(
      allowImplicitScrolling: allowImplicitScrolling,
      parent: buildParent(ancestor),
    );
  }

  @override
  final bool allowImplicitScrolling;
}
