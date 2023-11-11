part of countdown_timer;

class CountdownTimerPainter extends CustomPainter {
  CountdownTimerPainter({
    this.animation,
    this.progressStrokeColor,
    this.progressStrokeGradient,
    this.backStrokeColor,
    this.backStrokeGradient,
    this.strokeWidth,
    this.strokeCap,
    this.backgroundColor,
    this.isReverse,
    this.isReverseAnimation,
    this.backgroundGradient,
  }) : super(repaint: animation);

  final Animation<double>? animation;
  final Color? progressStrokeColor, backStrokeColor, backgroundColor;
  final double? strokeWidth;
  final StrokeCap? strokeCap;
  final bool? isReverse, isReverseAnimation;
  final Gradient? progressStrokeGradient,
      backStrokeGradient,
      backgroundGradient;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backStrokeColor!
      ..strokeWidth = strokeWidth!
      ..strokeCap = strokeCap!
      ..style = PaintingStyle.stroke;

    if (backStrokeGradient != null) {
      final rect = Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2);
      paint.shader = backStrokeGradient!.createShader(rect);
    } else {
      paint.shader = null;
    }

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    double progress = (animation!.value) * 2 * math.pi;
    double startAngle = math.pi * 1.5;

    // if ((!isReverse! && isReverseAnimation!) ||
    //     (isReverse! && isReverseAnimation!)) {
    //   progress = progress * -1;
    //   startAngle = -math.pi / 2;
    // }

    if (progressStrokeGradient != null) {
      final rect = Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2);
      paint.shader = progressStrokeGradient!.createShader(rect);
    } else {
      paint.shader = null;
      paint.color = progressStrokeColor!;
    }

    canvas.drawArc(Offset.zero & size, startAngle, progress, false, paint);

    if (backgroundColor != null || backgroundGradient != null) {
      final backgroundPaint = Paint();

      if (backgroundGradient != null) {
        final rect = Rect.fromCircle(
            center: size.center(Offset.zero), radius: size.width / 2.2);
        backgroundPaint.shader = backgroundGradient!.createShader(rect);
      } else {
        backgroundPaint.color = backgroundColor!;
      }
      canvas.drawCircle(
          size.center(Offset.zero), size.width / 2.2, backgroundPaint);
    }
  }

  @override
  bool shouldRepaint(CountdownTimerPainter oldDelegate) {
    return animation!.value != oldDelegate.animation!.value ||
        backStrokeColor != oldDelegate.backStrokeColor ||
        progressStrokeColor != oldDelegate.progressStrokeColor;
  }
}
