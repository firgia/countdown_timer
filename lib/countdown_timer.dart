library countdown_timer;

import 'package:flutter/material.dart';
import 'dart:math' as math;

part 'countdown_timer.controller.dart';
part 'countdown_timer.painter.dart';

class CountDownTimer extends StatefulWidget {
  /// Filling Color for Countdown Widget.
  final Color fillColor;

  /// Filling Gradient for Countdown Widget.
  final Gradient? fillGradient;

  /// Ring Color for Countdown Widget.
  final Color ringColor;

  /// Ring Gradient for Countdown Widget.
  final Gradient? ringGradient;

  /// Background Color for Countdown Widget.
  final Color? backgroundColor;

  /// Background Gradient for Countdown Widget.
  final Gradient? backgroundGradient;

  /// This Callback will execute when the Countdown Ends.
  final VoidCallback? onComplete;

  /// This Callback will execute when the Countdown Starts.
  final VoidCallback? onStart;

  /// This Callback will execute when the Countdown Changes.
  final Function(Duration duration)? onChange;

  /// Countdown duration in Seconds.
  final int duration;

  /// Countdown initial elapsed Duration in Seconds.
  final int initialDuration;

  /// Width of the Countdown Widget.
  final double width;

  /// Height of the Countdown Widget.
  final double height;

  /// Border Thickness of the Countdown Ring.
  final double strokeWidth;

  /// Begin and end contours with a flat edge and no extension.
  final StrokeCap strokeCap;

  /// Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
  final bool isReverse;

  /// Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
  final bool isReverseAnimation;

  /// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
  final CountdownTimerController? controller;

  /// Handles the timer start.
  final bool autoStart;

  /// Build custom widget for showing [duration]
  final Widget Function(BuildContext context, Duration duration)? builder;

  const CountDownTimer({
    required this.width,
    required this.height,
    required this.duration,
    required this.fillColor,
    required this.ringColor,
    this.backgroundColor,
    this.fillGradient,
    this.ringGradient,
    this.backgroundGradient,
    this.initialDuration = 0,
    this.isReverse = false,
    this.isReverseAnimation = false,
    this.onComplete,
    this.onStart,
    this.onChange,
    this.strokeWidth = 5.0,
    this.strokeCap = StrokeCap.butt,
    super.key,
    this.autoStart = true,
    this.controller,
    this.builder,
  }) : assert(initialDuration <= duration);

  @override
  CountDownTimerState createState() => CountDownTimerState();
}

class CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _countDownAnimation;
  late CountdownTimerController countDownController;

  Duration? prevDuration;
  bool isFirstFrame = true;

  Duration getDuration() {
    if (widget.isReverse &&
        !widget.autoStart &&
        !countDownController.isStarted) {
      return Duration(seconds: widget.duration);
    } else {
      Duration duration = _controller.duration! * _controller.value;
      return duration;
    }
  }

  void _setAnimation() {
    if (widget.autoStart) {
      if (widget.isReverse) {
        _controller.reverse(from: 1);
      } else {
        _controller.forward();
      }
    }
  }

  void _setAnimationDirection() {
    if ((!widget.isReverse && widget.isReverseAnimation) ||
        (widget.isReverse && !widget.isReverseAnimation)) {
      _countDownAnimation =
          Tween<double>(begin: 1, end: 0).animate(_controller);
    }
  }

  void _setController() {
    countDownController._state = this;
    countDownController._isReverse = widget.isReverse;
    countDownController._initialDuration = widget.initialDuration;
    countDownController._duration = widget.duration;
    countDownController.isStarted = widget.autoStart;

    if (widget.initialDuration > 0 && widget.autoStart) {
      if (widget.isReverse) {
        _controller.value = 1 - (widget.initialDuration / widget.duration);
      } else {
        _controller.value = (widget.initialDuration / widget.duration);
      }

      countDownController.start();
    }
  }

  void _onStart() {
    if (widget.onStart != null) widget.onStart!();
  }

  void _onComplete() {
    if (widget.onComplete != null) widget.onComplete!();
  }

  @override
  void initState() {
    countDownController = widget.controller ?? CountdownTimerController();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          _onStart();
          break;

        case AnimationStatus.reverse:
          _onStart();
          break;

        case AnimationStatus.dismissed:
          _onComplete();
          break;

        case AnimationStatus.completed:

          /// [AnimationController]'s value is manually set to [1.0] that's why
          /// [AnimationStatus.completed] is invoked here this animation is
          /// [isReverse] Only call the [_onComplete] block when the animation
          /// is not reversed.
          if (!widget.isReverse) _onComplete();
          break;
        default:
      }
    });

    _setAnimation();
    _setAnimationDirection();
    _setController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            Duration duration = getDuration();

            if (!isFirstFrame &&
                widget.onChange != null &&
                duration != prevDuration) {
              widget.onChange!(duration);
              prevDuration = duration;
            }

            if (isFirstFrame) isFirstFrame = false;

            return Align(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CountdownTimerPainter(
                          animation: _countDownAnimation ?? _controller,
                          fillColor: widget.fillColor,
                          fillGradient: widget.fillGradient,
                          ringColor: widget.ringColor,
                          ringGradient: widget.ringGradient,
                          strokeWidth: widget.strokeWidth,
                          strokeCap: widget.strokeCap,
                          isReverse: widget.isReverse,
                          isReverseAnimation: widget.isReverseAnimation,
                          backgroundColor: widget.backgroundColor,
                          backgroundGradient: widget.backgroundGradient,
                        ),
                      ),
                    ),
                    if (widget.builder != null)
                      widget.builder!(context, duration),
                    // widget.isTimerTextShown
                    //     ? Align(
                    //         alignment: FractionalOffset.center,
                    //         child: Text(
                    //           time,
                    //           style: widget.textStyle ??
                    //               const TextStyle(
                    //                 fontSize: 16.0,
                    //                 color: Colors.black,
                    //               ),
                    //           textAlign: widget.textAlign,
                    //         ),
                    //       )
                    //     : Container(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}
