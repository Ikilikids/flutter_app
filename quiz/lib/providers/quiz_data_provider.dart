import "package:quiz/quiz.dart";
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 各アプリのフォルダ構成に合わせてパスを調整してください
// import '../assistance/quiz_download.dart';

part 'quiz_data_provider.g.dart';

/// ① CSVパース済みの全データを保持する（アプリ起動時に1回だけ実行）

/// ② 今プレイするゲームのために「フィルタリングされた」マップを保持する器
@Riverpod(keepAlive: true)
class ActiveGameMap extends _$ActiveGameMap {
  @override
  Map<int, List<PartData>> build() => {};

  void update(Map<int, List<PartData>> map) {
    state = map;
  }
}
