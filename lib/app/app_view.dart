part of 'app.dart';

class APIClient extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    final isDev = !const bool.fromEnvironment('dart.vm.product');
    if (isDev) {
      baseUrl = 'http://localhost:9999';
    }
  }

  Future<Response<Map<String, dynamic>>> inc() async {
    return post<Map<String, dynamic>>('/inc', {});
  }
}

class Application extends StatelessWidget {
  final APIClient api = Get.put(APIClient());
  final RxInt count = 0.obs;

  Application({super.key});

  Future<void> _handleIncrement() async {
    final r = await api.inc();
    if (r.hasError || r.body == null) {
      return;
    }

    final n = r.body!['n'];
    if (n is int) {
      count(n);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stress App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D79F3)),
        fontFamily: 'Roboto',
      ),
      home: LoginScreen(
        onLoginSuccess: () async {
          Get.offAll(() => LoadingScreen(
                statusText: 'Breathe in... Preparing your wellness space',
                autoNavigateAfter: const Duration(milliseconds: 2500),
                onComplete: () {
                  Get.offAll(() => HomeScreen(
                        count: count,
                        onIncrement: _handleIncrement,
                      ));
                },
              ));
        },
      ),
    );
  }
}
