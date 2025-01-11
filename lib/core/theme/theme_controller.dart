import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  
  final _prefs = Get.find<SharedPreferences>();
  static const _key = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _isDarkMode.value = _prefs.getBool(_key) ?? false;
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _prefs.setBool(_key, _isDarkMode.value);
    update();
  }
} 