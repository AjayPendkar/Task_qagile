import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3));
    await Get.offAllNamed('/home');
  }
} 