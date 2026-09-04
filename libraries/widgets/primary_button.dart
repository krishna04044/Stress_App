import 'package:flutter/material.dart';

/// Native Flutter implementation of Uiverse.io Tactical Skewed Button (Valorant-style)
/// Features outer bracket borders, corner accent boxes, and a smooth skewed background slide transition.
class TacticalPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsets padding;

  const TacticalPrimaryButton({
    super.key,
    this.text = 'BUTTON',
    this.onPressed,
    this.backgroundColor = const Color(0xFF0E1822),
    this.accentColor = const Color(0xFFFF4655),
    this.textColor = Colors.white,
    this.fontSize = 13.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
  });

  @override
  State<TacticalPrimaryButton> createState() => _TacticalPrimaryButtonState();
}

class _TacticalPrimaryButtonState extends State<TacticalPrimaryButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _animController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeBorderColor =
        _isHovered ? widget.accentColor : widget.backgroundColor;
    final topLeftDotColor = _isHovered ? Colors.white : widget.backgroundColor;
    final bottomRightDotColor =
        _isHovered ? Colors.white : widget.accentColor;

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: CustomPaint(
            painter: _OuterBorderPainter(
              borderColor: widget.backgroundColor,
            ),
            child: Container(
              margin: const EdgeInsets.all(6), // Outer bracket margin
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Button Base Container with Skewed Background Painter
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _TacticalButtonBackgroundPainter(
                          progress: _slideAnimation.value,
                          bgColor: widget.backgroundColor,
                          accentColor: widget.accentColor,
                          borderColor: activeBorderColor,
                        ),
                        child: Container(
                          padding: widget.padding,
                          child: Text(
                            widget.text.toUpperCase(),
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: widget.fontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Top-Left Corner Accent (.primary-button:before)
                  Positioned(
                    top: -1,
                    left: -1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 4,
                      height: 4,
                      color: topLeftDotColor,
                    ),
                  ),

                  // Bottom-Right Corner Accent (.primary-button:after)
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 6,
                      height: 6,
                      color: bottomRightDotColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the skewed polygon background slide effect (.shape)
class _TacticalButtonBackgroundPainter extends CustomPainter {
  final double progress;
  final Color bgColor;
  final Color accentColor;
  final Color borderColor;

  _TacticalButtonBackgroundPainter({
    required this.progress,
    required this.bgColor,
    required this.accentColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base background rect
    final bgPaint = Paint()..color = bgColor;
    canvas.drawRect(rect, bgPaint);

    // Skewed polygon path
    if (progress > 0) {
      final skewWidth = size.width * 0.45;
      final slideOffset = (1.0 - progress) * size.width * 1.5 - size.width * 0.3;

      final path = Path()
        ..moveTo(slideOffset + skewWidth * 0.3, 0)
        ..lineTo(slideOffset + skewWidth + size.width * 0.6, 0)
        ..lineTo(slideOffset + size.width * 0.6, size.height)
        ..lineTo(slideOffset - skewWidth * 0.3, size.height)
        ..close();

      final accentPaint = Paint()..color = accentColor;
      canvas.save();
      canvas.clipRect(rect);
      canvas.drawPath(path, accentPaint);
      canvas.restore();
    }

    // Border paint
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TacticalButtonBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderColor != borderColor;
  }
}

/// Paints outer bracket borders (.button-borders)
class _OuterBorderPainter extends CustomPainter {
  final Color borderColor;

  _OuterBorderPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const offset = 4.0;
    final halfHeight = size.height * 0.5;

    // Top Bracket (.button-borders:before)
    final topPath = Path()
      ..moveTo(0, halfHeight)
      ..lineTo(0, offset)
      ..lineTo(size.width, offset)
      ..lineTo(size.width, halfHeight);
    canvas.drawPath(topPath, paint);

    // Bottom Bracket (.button-borders:after)
    final bottomPath = Path()
      ..moveTo(0, halfHeight)
      ..lineTo(0, size.height - offset)
      ..lineTo(size.width, size.height - offset)
      ..lineTo(size.width, halfHeight);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(covariant _OuterBorderPainter oldDelegate) => false;
}
