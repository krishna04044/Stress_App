part of 'app.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stress App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF3A8CF)),
        fontFamily: 'Roboto',
      ),
      home: SelfTestsScreen(
        onBackToLogin: () => Get.toNamed('/login'),
      ),
      getPages: [
        GetPage(
          name: '/home',
          page: () => SelfTestsScreen(
            onBackToLogin: () => Get.toNamed('/login'),
          ),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(
            onLoginSuccess: () async {
              Get.offAllNamed('/home');
            },
          ),
        ),
        GetPage(
          name: '/nature',
          page: () => Scaffold(
            body: NatureSceneBackground(
              child: Center(
                child: PlayfulCartoonButton(
                  text: 'Start Journey',
                  icon: Icons.spa_rounded,
                  onPressed: () => Get.toNamed('/home'),
                ),
              ),
            ),
          ),
        ),
        GetPage(
          name: '/loading',
          page: () => LoadingScreen(
            autoNavigateAfter: const Duration(seconds: 2),
            onComplete: () => Get.offAllNamed('/home'),
          ),
        ),
      ],
    );
  }
}
