import 'package:flutter/material.dart';

/// Reusable Playful 3D Cartoon Button converted from CSS.
///
/// Features:
/// - Pastel pink (#F3A8CF) face with dark navy (#11184F) border and 3D extrusion shadow.
/// - Tactile pressing animation (lifts up 2px on hover, compresses down 3px when pressed).
/// - Completely responsive and customizable for mobile and desktop.
class PlayfulCartoonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color hoverColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isEnabled;

  const PlayfulCartoonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor = const Color(0xFFF3A8CF),
    this.hoverColor = const Color(0xFFE995C2),
    this.textColor = const Color(0xFF11184F),
    this.borderColor = const Color(0xFF11184F),
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
    this.borderRadius = 18,
    this.isEnabled = true,
  });

  @override
  State<PlayfulCartoonButton> createState() => _PlayfulCartoonButtonState();
}

class _PlayfulCartoonButtonState extends State<PlayfulCartoonButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled || widget.onPressed == null) {
      return _buildFace(
        bg: widget.backgroundColor.withValues(alpha: 0.5),
        shadowY: 3,
        translateY: 2,
      );
    }

    // 3D physics translation and shadow:
    // Normal: translateY = 0, shadow = 5
    // Hover: translateY = -2, shadow = 7
    // Pressed: translateY = 3, shadow = 2
    final double translateY = _isPressed ? 3.0 : (_isHovered ? -2.0 : 0.0);
    final double shadowY = _isPressed ? 2.0 : (_isHovered ? 7.0 : 5.0);
    final Color currentBg = _isHovered ? widget.hoverColor : widget.backgroundColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuad,
          transform: Matrix4.translationValues(0, translateY, 0),
          child: _buildFace(
            bg: currentBg,
            shadowY: shadowY,
            translateY: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildFace({required Color bg, required double shadowY, required double translateY}) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.borderColor,
            offset: Offset(0, shadowY),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: widget.fontSize + 4, color: widget.textColor),
            const SizedBox(width: 8),
          ],
          Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
