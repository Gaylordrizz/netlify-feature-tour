import 'package:flutter/material.dart';

/// A medium-sized loading spinner for full page loads.
///
/// - Spins clockwise
/// - Light pink on the right, gold on the left
/// - No set duration; spins as long as needed
class PageLoadingSpinner extends StatefulWidget {
  const PageLoadingSpinner({Key? key}) : super(key: key);

  @override
  State<PageLoadingSpinner> createState() => _PageLoadingSpinnerState();
}

class _PageLoadingSpinnerState extends State<PageLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 48,
        height: 48,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 6.28319, // 2 * pi
              child: CustomPaint(
                painter: _SpinnerPainter(),
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Gold on the left (pi to 2pi), pink on the right (0 to pi)
    paint.shader = const SweepGradient(
      startAngle: 0,
      endAngle: 6.28319, // 2 * pi
      stops: [0.0, 0.499, 0.5, 1.0],
      colors: [
        Color(0xFFFFB6C1), // Light Pink
        Color(0xFFFFB6C1), // Light Pink
        Color(0xFFFFD700), // Gold
        Color(0xFFFFD700), // Gold
      ],
      transform: GradientRotation(-1.5708), // -pi/2, so pink is on right
    ).createShader(rect);

    final radius = (size.width - strokeWidth) / 2;
    // Draw a broken arc (worm chasing its own tail)
    // e.g., 270 degrees (3/4 of a circle), leaving a gap
    const double startAngle = 0;
    const double sweepAngle = 4.71239; // 3/2 * pi (270 degrees)
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
