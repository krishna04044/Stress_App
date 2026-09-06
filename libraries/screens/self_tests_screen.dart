import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/nature_scene_background.dart';

/// Interactive Self-Tests Screen with Ghibli Anime Moving Nature Background.
///
/// Features:
/// - Painted anime landscape background with animated leaves, sun glow, soaring birds & lake shimmer.
/// - Themed frosted glass container matching the sky, clouds, and floral palette.
/// - Top-left 3D cartoon back button navigating directly to Login page.
/// - "Discover Yourself with Self-Tests" typography with frosted header pill.
/// - Pop-out interactive cards with pastel cloud-pink highlights and 3D elevation.
/// - Pure frontend only (zero backend/API).
class SelfTestsScreen extends StatefulWidget {
  final VoidCallback? onBackToLogin;

  const SelfTestsScreen({super.key, this.onBackToLogin});

  @override
  State<SelfTestsScreen> createState() => _SelfTestsScreenState();
}

class _SelfTestsScreenState extends State<SelfTestsScreen> {
  int _selectedIndex = 1; // Personality Type active by default

  final List<_TestItem> _tests = const [
    _TestItem('adhd', 'ADHD', 'Focus & cognitive patterns', Color(0xFFF0EBF8), '🧠'),
    _TestItem('personality', 'Personality Type', 'Discover your core traits', Color(0xFFFFF0F5), '🎭'),
    _TestItem('trauma', 'Childhood Trauma', 'Healing your inner child', Color(0xFFEBF3FC), '🌱'),
    _TestItem('mood', 'Mood Disorder', 'Track emotional balance', Color(0xFFFFF3EB), '🌤️'),
    _TestItem('love', 'Love Language', 'How you express & receive love', Color(0xFFFFEEF4), '💖'),
  ];

  void _showTestPreview(BuildContext context, _TestItem test) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(test.badgeEmoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(test.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF11184F))),
                      Text(test.subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('This test takes ~2 minutes and includes 10 self-reflective questions. (UI Frontend Demo)',
                style: TextStyle(fontSize: 14, color: Color(0xFF4B5563), height: 1.4)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF11184F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Start Assessment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF11184F);

    return Scaffold(
      body: NatureSceneBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top navigation row with Top-Left Login button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        key: const Key('top_left_login_btn'),
                        onTap: widget.onBackToLogin ?? () => Get.toNamed('/login'),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: navy, width: 1.8),
                            boxShadow: const [
                              BoxShadow(color: navy, offset: Offset(0, 3)),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: navy),
                              SizedBox(width: 6),
                              Text('Login', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: navy)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Header title matching sky & cloud aesthetic
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(color: navy.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Text('Discover Yourself', textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: navy, letterSpacing: -0.5)),
                        Text('with Self-Tests', textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: navy, letterSpacing: -0.5)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Frosted glass card container hosting self-test items
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.80),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.95), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: navy.withValues(alpha: 0.10),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _tests.length,
                              itemBuilder: (context, index) {
                                final test = _tests[index];
                                final isSelected = _selectedIndex == index;
                                return _buildCard(
                                  test: test,
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() => _selectedIndex = index);
                                    if (isSelected) _showTestPreview(context, test);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildCard({required _TestItem test, required bool isSelected, required VoidCallback onTap}) {
    const navy = Color(0xFF11184F);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(horizontal: isSelected ? 4 : 14, vertical: isSelected ? 8 : 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('test_card_${test.id}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: isSelected ? 16 : 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFCE7F3) : Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? const Color(0xFFF3A8CF) : const Color(0xFFE2E8F0),
                width: isSelected ? 2.2 : 1.5,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFFF3A8CF).withValues(alpha: 0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: test.badgeBg, borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: Text(test.badgeEmoji, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(test.title, style: TextStyle(fontSize: isSelected ? 18 : 16, fontWeight: FontWeight.w800, color: navy)),
                      const SizedBox(height: 3),
                      Text(test.subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: navy.withValues(alpha: 0.65))),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [
                      BoxShadow(color: navy.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2)),
                    ]),
                    child: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: navy),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TestItem {
  final String id, title, subtitle, badgeEmoji;
  final Color badgeBg;
  const _TestItem(this.id, this.title, this.subtitle, this.badgeBg, this.badgeEmoji);
}
