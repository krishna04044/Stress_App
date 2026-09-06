import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

/// The existing main/home screen displaying the FastAPI counter and wellness status.
class HomeScreen extends StatelessWidget {
  final RxInt count;
  final Future<void> Function()? onIncrement;
  final VoidCallback? onLogout;

  const HomeScreen({
    super.key,
    required this.count,
    this.onIncrement,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress App'),
        actions: [
          IconButton(
            tooltip: 'View Zen Loading Screen',
            icon: const Icon(Icons.spa_rounded),
            onPressed: () {
              Get.to(() => LoadingScreen(
                    statusText: 'Breathe in... Calming your mind',
                    onDismiss: () => Get.back(),
                  ));
            },
          ),
          IconButton(
            tooltip: 'Log Out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: onLogout ??
                () {
                  Get.offAll(() => LoginScreen(
                        onLoginSuccess: () async {
                          Get.offAll(() => LoadingScreen(
                                statusText: 'Breathe in... Preparing your space',
                                autoNavigateAfter: const Duration(milliseconds: 2500),
                                onComplete: () {
                                  Get.offAll(() => HomeScreen(
                                        count: count,
                                        onIncrement: onIncrement,
                                      ));
                                },
                              ));
                        },
                      ));
                },
          ),
        ],
      ),
      body: Center(
        child: Obx(() => Text(
              'clicked ${count.value} times',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onIncrement,
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
