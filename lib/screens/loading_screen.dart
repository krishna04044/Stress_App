import 'package:flutter/material.dart';
import '../animations/zen_breathing_loader.dart';

/// Full-screen Zen Loading and Breathing Screen for stress relief.
class LoadingScreen extends StatefulWidget {
  final String statusText;
  final VoidCallback? onDismiss;
  final Duration? autoNavigateAfter;
  final VoidCallback? onComplete;

  const LoadingScreen({
    super.key,
    this.statusText = 'Breathe in... Calming your mind',
    this.onDismiss,
    this.autoNavigateAfter,
    this.onComplete,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.autoNavigateAfter != null && widget.onComplete != null) {
      Future.delayed(widget.autoNavigateAfter!, () {
        if (mounted) widget.onComplete!();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color(0xFF7E9987).withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7E9987).withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ZenBreathingLoader(
                        size: 160,
                        primaryColor: Color(0xFF7E9987),
                        accentColor: Color(0xFFCDB4DB),
                        label: '',
                      ),
                      const SizedBox(height: 36),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7E9987).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.spa_rounded, size: 18, color: Color(0xFF7E9987)),
                            SizedBox(width: 8),
                            Text(
                              'ZEN MODE ACTIVE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: Color(0xFF7E9987),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.statusText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3531),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preparing your personalized wellness space',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2C3531).withValues(alpha: 0.6),
                        ),
                      ),
                      if (widget.onDismiss != null) ...[
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: widget.onDismiss,
                          child: const Text('Dismiss', style: TextStyle(color: Color(0xFF7E9987))),
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    '"Quiet the mind, and the soul will speak."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      color: const Color(0xFF2C3531).withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
