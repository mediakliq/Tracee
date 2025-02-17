// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _kMinFlingVelocity = 1.0; // Screen widths per second.

// An eyeballed value for the maximum time it takes
//for a page to animate forward
// if the user releases a page mid swipe.
const int _kMaxDroppedSwipePageForwardAnimationTime = 800; // Milliseconds.

// The maximum time for a page to get reset to it's original position if the
// user releases a page mid swipe.
const int _kMaxPageBackAnimationTime = 300; // Milliseconds.

class SimpleCupertinoBackGestureDetector<T> extends StatefulWidget {
  const SimpleCupertinoBackGestureDetector({
    Key? key,
    required this.route,
    required this.child,
    this.fractionalGesture = 0.1,
  }) : super(key: key);

  final Widget child;
  final PageRoute<T> route;
  final double fractionalGesture;

  @override
  SimpleCupertinoBackGestureDetectorState<T> createState() =>
      SimpleCupertinoBackGestureDetectorState<T>();
}

class SimpleCupertinoBackGestureDetectorState<T>
    extends State<SimpleCupertinoBackGestureDetector<T>> {
  SimpleCupertinoBackGestureController<T>? _backGestureController;
  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  bool isPopGestureEnabled() {
    final route = widget.route;
    // If there's nothing to go back to, then obviously we don't support
    // the back gesture.
    if (route.isFirst) return false;
    // If the route wouldn't actually pop if we popped it, then the gesture
    // would be really confusing (or would skip internal routes),
    //so disallow it.
    if (route.willHandlePopInternally) return false;
    // If attempts to dismiss this route might be vetoed such as in a page
    // with forms, then do not allow the user to dismiss the route with a swipe.
    // ignore: invalid_use_of_protected_member
    if (route.hasScopedWillPopCallback) return false;
    // Fullscreen dialogs aren't dismissible by back swipe.
    if (route.fullscreenDialog) return false;
    // If we're in an animation already, we cannot be manually swiped.
    if (route.animation!.status != AnimationStatus.completed) return false;
    // If we're being popped into, we also cannot be swiped until the pop above
    // it completes. This translates to our secondary animation being
    // dismissed.
    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }
    // If we're in a gesture already, we cannot start another.
    if (isPopGestureInProgress()) return false;

    // Looks like a back gesture would be welcome!
    return true;
  }

  /// True if an iOS-style back swipe pop gesture is currently
  /// underway for [route].
  ///
  /// This just check the route's [NavigatorState.userGestureInProgress].
  ///
  /// See also:
  ///
  ///  * [popGestureEnabled], which returns true if a user-triggered pop gesture
  ///    would be allowed.
  bool isPopGestureInProgress() {
    return widget.route.navigator!.userGestureInProgress;
  }

  // Called by SimpleCupertinoBackGestureDetector when a pop ("back") drag start
  // gesture is detected. The returned controller handles all of the subsequent
  // drag events.
  SimpleCupertinoBackGestureController<T> startPopGesture() {
    assert(isPopGestureEnabled());

    return SimpleCupertinoBackGestureController<T>(
      navigator: widget.route.navigator!,
      // ignore: invalid_use_of_protected_member
      controller: widget.route.controller!, // protected access
    );
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = startPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
        _convertToLogical(details.primaryDelta! / context.size!.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(_convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width));
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    // This can be called even if start is not called, paired with
    // the "down" event
    // that we don't consider here.
    _backGestureController?.dragEnd(0.0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (isPopGestureEnabled()) _recognizer.addPointer(event);
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // For devices with notches, the drag area needs to be larger on the side
    // that has the notch.
    final MediaQueryData media = MediaQuery.of(context);
    final double dragAreaWidth = max(
      Directionality.of(context) == TextDirection.ltr
          ? media.padding.left
          : media.padding.right,
      media.size.width * widget.fractionalGesture,
    );
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        PositionedDirectional(
          start: 0.0,
          bottom: 0.0,
          top: 0.0,
          width: dragAreaWidth,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class SimpleCupertinoBackGestureController<T> {
  /// Creates a controller for an iOS-style back gesture.
  ///
  /// The [navigator] and [controller] arguments must not be null.
  SimpleCupertinoBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    _dragStart();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  void _dragStart() {
    navigator.didStartUserGesture();
    controller.animateBack(controller.value, duration: Duration.zero);
  }

  /// The drag gesture has changed by [fractionalDelta]. The total range of the
  /// drag should be 0.0 to 1.0.
  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  /// The drag gesture has ended with a horizontal motion of
  /// [fractionalVelocity] as a fraction of screen width per second.
  void dragEnd(double velocity) {
    // Fling in the appropriate direction.
    // AnimationController.fling is guaranteed to
    // take at least one frame.
    //
    // This curve has been determined through rigorously eyeballing native iOS
    // animations.
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    final bool animateForward;

    // If the user releases the page before mid screen with sufficient velocity,
    // or after mid screen, we should animate the page out. Otherwise, the page
    // should be animated back in.
    if (velocity.abs() >= _kMinFlingVelocity) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      // The closer the panel is to dismissing, the shorter the animation is.
      // We want to cap the animation time, but we want to use a linear curve
      // to determine it.
      final droppedPageForwardAnimationTime = min(
        lerpDouble(
                _kMaxDroppedSwipePageForwardAnimationTime, 0, controller.value)!
            .floor(),
        _kMaxPageBackAnimationTime,
      );
      controller.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      // This route is destined to pop at this point. Reuse navigator's pop.
      navigator.pop();

      // The popping may have finished inline if already at the
      // target destination.
      if (controller.isAnimating) {
        // Otherwise, use a custom popping animation duration and curve.
        final droppedPageBackAnimationTime = lerpDouble(
                0, _kMaxDroppedSwipePageForwardAnimationTime, controller.value)!
            .floor();
        controller.animateBack(0.0,
            duration: Duration(milliseconds: droppedPageBackAnimationTime),
            curve: animationCurve);
      }
    }

    if (controller.isAnimating) {
      // Keep the userGestureInProgress in true state so we don't change the
      // curve of the page transition mid-flight since CupertinoPageTransition
      // depends on userGestureInProgress.
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
