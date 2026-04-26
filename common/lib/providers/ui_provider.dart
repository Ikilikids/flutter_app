import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common.dart';

part 'ui_provider.g.dart';

/// ① タブ選択
@Riverpod(keepAlive: true)
class SelectedModeIndex extends _$SelectedModeIndex {
  @override
  int build() => 0;
  void update(int index) => state = index;
}

/// ② 選ばれている QuizId (初期値を設定して Non-nullable に)
@Riverpod(keepAlive: true)
class SelectedQuizId extends _$SelectedQuizId {
  @override
  QuizId build() {
    // 初期値として「最初のモードの最初の項目」を返す
    return allData.mid[0].detail[0].quizId;
  }

  void update(QuizId id) => state = id;
}

/// ③ 1件合体工場 (Family)
@Riverpod(keepAlive: true, dependencies: [quizStatusMap])
DetailConfig quizDetail(Ref ref, QuizId id) {
  final masterMid =
      allData.mid.firstWhere((m) => m.modeData.modeType == id.modeType);
  final detailData = masterMid.detail.firstWhere((d) => d.quizId == id);

  final status = ref.watch(quizStatusMapProvider.select((s) => s.value?[id]));

  return DetailConfig(
    appData: allData.appData,
    modeData: masterMid.modeData,
    detail: detailData,
    highScore: status?.highScore ?? 0.0,
    buttonType: status?.buttonType ?? QuizButtonType.play,
    qcount: status?.qCount ?? 5,
  );
}

/// ④ 現在選ばれている 1 件 (絶対に DetailConfig を返す)
@Riverpod(keepAlive: true, dependencies: [SelectedQuizId, quizDetail])
DetailConfig currentDetailConfig(Ref ref) {
  final id = ref.watch(selectedQuizIdProvider);
  // id は必ず存在するので、そのまま watch して返すだけ
  return ref.watch(quizDetailProvider(id));
}
