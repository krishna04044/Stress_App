import 'package:flutter/material.dart';

/// Native Flutter implementation of Uiverse.io Tooltip Animated Download Button
/// Features pill-shaped dark container, custom download SVG vector icon, hover opacity shift,
/// and smooth tooltip slide & fade animation.
class AnimatedDownloadButton extends StatefulWidget {
  final String text;
  final String tooltipText;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;

  const AnimatedDownloadButton({
    super.key,
    this.text = 'Download',
    this.tooltipText = 'Download',
    this.onPressed,
    this.backgroundColor = Colors.black,
    this.textColor = const Color(0xFFF1F1F1),
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  });

  @override
  State<AnimatedDownloadButton> createState() => _AnimatedDownloadButtonState();
}

class _AnimatedDownloadButtonState extends State<AnimatedDownloadButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
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
    final bgAlpha = _isHovered ? 0.7 : 0.8;

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
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Primary Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.backgroundColor.withValues(alpha: bgAlpha),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Download Vector Icon (M6 21H18M12 3V17M12 17L17 12M12 17L7 12)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CustomPaint(
                        painter: _DownloadIconPainter(color: widget.textColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Tooltip Animated Popup Container
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.tooltipText,
                      style: TextStyle(
                        color: widget.textColor.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the Download SVG Vector
class _DownloadIconPainter extends CustomPainter {
  final Color color;

  _DownloadIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Bottom Base Bar (M6 21H18)
    canvas.drawLine(
      Offset(w * 0.25, h * 0.875),
      Offset(w * 0.75, h * 0.875),
      paint,
    );

    // Vertical Arrow Shaft (M12 3V17)
    canvas.drawLine(
      Offset(w * 0.5, h * 0.125),
      Offset(w * 0.5, h * 0.708),
      paint,
    );

    // Arrow Right Head (M12 17L17 12)
    canvas.drawLine(
      Offset(w * 0.5, h * 0.708),
      Offset(w * 0.708, h * 0.5),
      paint,
    );

    // Arrow Left Head (M12 17L7 12)
    canvas.drawLine(
      Offset(w * 0.5, h * 0.708),
      Offset(w * 0.292, h * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _DownloadIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
