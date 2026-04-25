import 'package:common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz/quiz.dart';

import 'load_eng.dart';
import 'load_math.dart';

export 'quiz_models.dart';

Future<void> init(WidgetRef ref) async {
  Map<int, List<PartData>> filterdQuizData = {};
  final quizinfo = ref.read(currentDetailConfigProvider);
  final title = quizinfo.appData.appTitle;

  if (title == "とことん高校数学") {
    // Case 1: 高校数学
    filterdQuizData = await load(quizinfo);
  } else if (title == "appTitle") {
    // Case 2: 特殊モード (appTitle)
    final raw = await load(quizinfo);
    expandForAppTitle(ref, quizinfo, raw);
    filterdQuizData = raw;
  } else if (title.contains("英単語")) {
    // Case 3: 英単語
    filterdQuizData = await EngQuizLoader.load(ref, quizinfo);
  } else {
    return;
  }

  // マップを更新して通知
  ref.read(activeGameMapProvider.notifier).update(filterdQuizData);
}
