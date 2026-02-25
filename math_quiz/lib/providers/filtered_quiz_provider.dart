import 'package:flutter/foundation.dart';

import '../assistance/quiz_download.dart';

class FilteredQuizProvider with ChangeNotifier {
  // score が上のフラット構造
  Map<int, List<PartData>> _filteredListByScore = {};

  Map<int, List<PartData>> get filteredListByScore => _filteredListByScore;

  void setFilteredListByScore(Map<int, List<PartData>> list) {
    _filteredListByScore = list;
    // 通常は通知不要ですが、必要なら notifyListeners() を追加
    // notifyListeners();
  }
}
