import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';

part 'app_number.g.dart';

@Riverpod(keepAlive: true)
String initialNumber(Ref ref) => throw UnimplementedError();

@Riverpod(keepAlive: true, dependencies: [initialNumber])
class AppNumber extends _$AppNumber {
  @override
  String build() {
    return ref.watch(initialNumberProvider);
  }

  Future<void> setNumber(String number) async {
    final SharedPreferences prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('Number', number);

    state = number;
  }
}
