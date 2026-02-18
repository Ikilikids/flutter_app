import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_number.g.dart';

@riverpod
class AppNumber extends _$AppNumber {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('Number');
    return code ?? "mobile";
  }

  /// 言語変更 + 保存
  Future<void> setNumber(String Number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Number', Number);

    // 保存完了後に state 更新
    state = AsyncData(Number);
  }
}
