import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Immersive Anime/Ghibli Nature Landscape Background with Dynamic Moving Effects.
///
/// Features:
/// - Painted Studio Ghibli landscape backdrop with subtle ambient camera breathing.
/// - Ambient warm pulsing sun glow.
/// - Swirling green leaves fluttering across multiple depth planes.
/// - Soaring birds gliding smoothly across the sky.
/// - Shimmering lake light reflections.
/// - Supports an optional foreground [child] widget.
class NatureSceneBackground extends StatefulWidget {
  final Widget? child;

  const NatureSceneBackground({super.key, this.child});

  @override
  State<NatureSceneBackground> createState() => _NatureSceneBackgroundState();
}

class _NatureSceneBackgroundState extends State<NatureSceneBackground>
    with TickerProviderStateMixin {
  late final AnimationController _ambientCtrl;
  late final AnimationController _leafCtrl;
  late final AnimationController _birdCtrl;
  late final AnimationController _sunGlowCtrl;
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _ambientCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 16))..repeat(reverse: true);
    _leafCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 9))..repeat();
    _birdCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 22))..repeat();
    _sunGlowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ambientCtrl.dispose();
    _leafCtrl.dispose();
    _birdCtrl.dispose();
    _sunGlowCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. Base Painted Landscape Artwork with gentle ambient breathe
            AnimatedBuilder(
              animation: _ambientCtrl,
              builder: (context, child) {
                final scale = 1.0 + (_ambientCtrl.value * 0.035);
                final offsetY = math.sin(_ambientCtrl.value * math.pi) * 6;
                return Transform.scale(
                  scale: scale,
                  child: Transform.translate(
                    offset: Offset(0, offsetY),
                    child: Image.asset(
                      'assets/images/nature_scene_bg.png',
                      fit: BoxFit.cover,
                      width: w,
                      height: h,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF79C9F2), Color(0xFFB8E5F5), Color(0xFFE9F5E8)],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // 2. Glowing Sun Aura Pulse (Top-Right around the painted sun)
            Positioned(
              top: h * 0.22,
              right: w * 0.16,
              child: AnimatedBuilder(
                animation: _sunGlowCtrl,
                builder: (context, child) {
                  final glow = 0.35 + (_sunGlowCtrl.value * 0.35);
                  return Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFF7D6).withValues(alpha: glow),
                          blurRadius: 36 + (_sunGlowCtrl.value * 18),
                          spreadRadius: 10 + (_sunGlowCtrl.value * 8),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 3. Lake Water Shimmer Highlights (Mid-bottom lake area)
            Positioned(
              top: h * 0.76,
              left: w * 0.30,
              width: w * 0.50,
              height: h * 0.08,
              child: AnimatedBuilder(
                animation: _shimmerCtrl,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _LakeShimmerPainter(progress: _shimmerCtrl.value),
                  );
                },
              ),
            ),

            // 4. Soaring Birds Gliding Across the Sky
            AnimatedBuilder(
              animation: _birdCtrl,
              builder: (context, child) {
                final progress = _birdCtrl.value;
                final birdX = -120 + (w + 240) * progress;
                final birdY = (h * 0.38) + math.sin(progress * 4 * math.pi) * 22;
                return Positioned(
                  left: birdX,
                  top: birdY,
                  child: Transform.rotate(
                    angle: -0.06 + math.sin(progress * 4 * math.pi) * 0.04,
                    child: const _FlockOfBirds(),
                  ),
                );
              },
            ),

            // 5. Swirling Floating Leaves in Depth
            AnimatedBuilder(
              animation: _leafCtrl,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Distant small leaves
                    _buildSwirlingLeaf(w, h, 0.20, 0.20, 0.40, _leafCtrl.value, 18, 0.7),
                    _buildSwirlingLeaf(w, h, 0.65, 0.30, 0.35, (_leafCtrl.value + 0.35) % 1.0, 16, 0.6),
                    _buildSwirlingLeaf(w, h, 0.85, 0.52, 0.25, (_leafCtrl.value + 0.70) % 1.0, 19, 0.7),

                    // Midground crisp leaves
                    _buildSwirlingLeaf(w, h, 0.35, 0.40, 0.45, (_leafCtrl.value + 0.15) % 1.0, 26, 1.0),
                    _buildSwirlingLeaf(w, h, 0.12, 0.50, 0.40, (_leafCtrl.value + 0.55) % 1.0, 24, 0.95),
                    _buildSwirlingLeaf(w, h, 0.72, 0.62, 0.35, (_leafCtrl.value + 0.82) % 1.0, 27, 1.0),

                    // Foreground large drifting leaves
                    _buildSwirlingLeaf(w, h, 0.06, 0.68, 0.30, (_leafCtrl.value + 0.42) % 1.0, 36, 1.2),
                    _buildSwirlingLeaf(w, h, 0.90, 0.75, 0.25, (_leafCtrl.value + 0.90) % 1.0, 34, 1.1),
                  ],
                );
              },
            ),

            // 6. Optional Foreground Child (Buttons, Form, Headers)
            if (widget.child != null) Positioned.fill(child: widget.child!),
          ],
        );
      },
    );
  }

  Widget _buildSwirlingLeaf(
    double w,
    double h,
    double startXRatio,
    double startYRatio,
    double travelDistRatio,
    double progress,
    double size,
    double scale,
  ) {
    final travelX = (w * travelDistRatio) * progress;
    final travelY = (h * 0.18) * progress;
    final swayX = math.sin((progress * 2 + startXRatio) * 2 * math.pi) * 45;
    final swayY = math.cos((progress * 2 + startYRatio) * 2 * math.pi) * 20;
    final x = (w * startXRatio) + travelX + swayX;
    final y = (h * startYRatio) + travelY + swayY;
    final rotation = math.sin((progress + startXRatio) * 2 * math.pi) * 0.6;
    final opacity = progress < 0.15 ? (progress / 0.15) : (progress > 0.85 ? (1.0 - progress) / 0.15 : 1.0);

    return Positioned(
      left: x,
      top: y,
      child: Transform.scale(
        scale: scale,
        child: Transform.rotate(
          angle: rotation,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: const Text('🍃', style: TextStyle(fontSize: 26, decoration: TextDecoration.none)),
          ),
        ),
      ),
    );
  }
}

class _FlockOfBirds extends StatelessWidget {
  const _FlockOfBirds();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SingleBird(size: 16),
        SizedBox(width: 14),
        Padding(padding: EdgeInsets.only(top: 8), child: _SingleBird(size: 12)),
        SizedBox(width: 18),
        Padding(padding: EdgeInsets.only(bottom: 6), child: _SingleBird(size: 10)),
      ],
    );
  }
}

class _SingleBird extends StatelessWidget {
  final double size;

  const _SingleBird({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.5),
      painter: _BirdPainter(),
    );
  }
}

class _BirdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(0, h)
      ..quadraticBezierTo(w * 0.25, 0, w * 0.50, h * 0.7)
      ..quadraticBezierTo(w * 0.75, 0, w, h);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LakeShimmerPainter extends CustomPainter {
  final double progress;

  const _LakeShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE3F7FF).withValues(alpha: 0.35 + (progress * 0.35))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    void drawGlint(double xRatio, double yRatio, double length) {
      final x = w * xRatio;
      final y = h * yRatio;
      canvas.drawLine(Offset(x, y), Offset(x + length, y), paint);
    }

    drawGlint(0.15 + (progress * 0.05), 0.20, 36);
    drawGlint(0.40 - (progress * 0.04), 0.45, 48);
    drawGlint(0.65 + (progress * 0.03), 0.30, 42);
    drawGlint(0.28 + (progress * 0.02), 0.70, 54);
    drawGlint(0.55 - (progress * 0.03), 0.85, 30);
  }

  @override
  bool shouldRepaint(covariant _LakeShimmerPainter oldDelegate) => oldDelegate.progress != progress;
}
