import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Reusable Zen Breathing Loader Animation
/// Converts Uiverse.io CSS keyframes (rot, toBig, toBig2, breath) into Flutter animations.
class ZenBreathingLoader extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color accentColor;
  final String label;

  const ZenBreathingLoader({
    super.key,
    this.size = 180.0,
    this.primaryColor = const Color(0xFF7E9987),
    this.accentColor = const Color(0xFFCDB4DB),
    this.label = 'Breathe in... Calming your mind',
  });

  @override
  State<ZenBreathingLoader> createState() => _ZenBreathingLoaderState();
}

class _ZenBreathingLoaderState extends State<ZenBreathingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateRot(double t) {
    if (t <= 0.3) {
      return (t / 0.3) * 2 * math.pi;
    } else if (t <= 0.5) {
      return 2 * math.pi;
    } else if (t <= 0.8) {
      return (1.0 - ((t - 0.5) / 0.3)) * 2 * math.pi;
    } else {
      return 0.0;
    }
  }

  double _calculateScale(double t, double offsetMs) {
    double progress = (t + offsetMs) % 1.0;
    if (progress <= 0.3) {
      return 1.0;
    } else if (progress <= 0.5) {
      double p = (progress - 0.3) / 0.2;
      return 1.0 + p * 1.5;
    } else if (progress <= 0.8) {
      return 2.5;
    } else {
      double p = (progress - 0.8) / 0.2;
      return 2.5 - p * 1.5;
    }
  }

  double _calculateTranslateX(double t, double direction) {
    if (t <= 0.3) {
      return 0.0;
    } else if (t <= 0.5) {
      double p = (t - 0.3) / 0.2;
      return p * 8.0 * direction;
    } else if (t <= 0.8) {
      return 8.0 * direction;
    } else {
      double p = (t - 0.8) / 0.2;
      return (1.0 - p) * 8.0 * direction;
    }
  }

  double _calculateBreath(double t) {
    if (t <= 0.15) return 1.0;
    if (t <= 0.40) return 1.0 + ((t - 0.15) / 0.25) * 0.1;
    if (t <= 0.65) return 1.1 - ((t - 0.40) / 0.25) * 0.1;
    if (t <= 0.90) return 1.0 + ((t - 0.65) / 0.25) * 0.1;
    return 1.1 - ((t - 0.90) / 0.10) * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final breathScale = _calculateBreath(t);
        final rotAngle = _calculateRot(t);
        final scale1 = _calculateScale(t, 0.5);
        final scale2 = _calculateScale(t, 0.0);
        final transX1 = _calculateTranslateX(t, -1.0);
        final transX2 = _calculateTranslateX(t, 1.0);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: breathScale,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: _LoaderPainter(
                    rotAngle: rotAngle,
                    scale1: scale1,
                    scale2: scale2,
                    transX1: transX1,
                    transX2: transX2,
                    primaryColor: widget.primaryColor,
                    accentColor: widget.accentColor,
                  ),
                ),
              ),
            ),
            if (widget.label.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.primaryColor.withValues(alpha: 0.9),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final double rotAngle;
  final double scale1;
  final double scale2;
  final double transX1;
  final double transX2;
  final Color primaryColor;
  final Color accentColor;

  _LoaderPainter({
    required this.rotAngle,
    required this.scale1,
    required this.scale2,
    required this.transX1,
    required this.transX2,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.12;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotAngle);

    final blurPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    canvas.save();
    canvas.translate(transX1, 0);
    canvas.scale(scale1);
    blurPaint.color = primaryColor.withValues(alpha: 0.35);
    canvas.drawCircle(Offset(-baseRadius, 0), baseRadius * 0.8, blurPaint);

    final paint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(-baseRadius, 0), baseRadius * 0.7, paint1);
    canvas.restore();

    canvas.save();
    canvas.translate(transX2, 0);
    canvas.scale(scale2);
    blurPaint.color = accentColor.withValues(alpha: 0.35);
    canvas.drawCircle(Offset(baseRadius, 0), baseRadius * 0.8, blurPaint);

    final paint2 = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(baseRadius, 0), baseRadius * 0.7, paint2);
    canvas.restore();

    final ringPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset.zero, size.width * 0.38, ringPaint);

    final dotPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.38, 0), 4.0, dotPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LoaderPainter oldDelegate) => true;
}
