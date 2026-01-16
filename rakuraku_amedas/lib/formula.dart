import 'package:flutter/material.dart';

String hankakuToZenkakuKana(String input) {
  const hankaku = [
    'ｱ',
    'ｲ',
    'ｳ',
    'ｴ',
    'ｵ',
    'ｶ',
    'ｷ',
    'ｸ',
    'ｹ',
    'ｺ',
    'ｻ',
    'ｼ',
    'ｽ',
    'ｾ',
    'ｿ',
    'ﾀ',
    'ﾁ',
    'ﾂ',
    'ﾃ',
    'ﾄ',
    'ﾅ',
    'ﾆ',
    'ﾇ',
    'ﾈ',
    'ﾉ',
    'ﾊ',
    'ﾋ',
    'ﾌ',
    'ﾍ',
    'ﾎ',
    'ﾏ',
    'ﾐ',
    'ﾑ',
    'ﾒ',
    'ﾓ',
    'ﾔ',
    'ﾕ',
    'ﾖ',
    'ﾗ',
    'ﾘ',
    'ﾙ',
    'ﾚ',
    'ﾛ',
    'ﾜ',
    'ｦ',
    'ﾝ',
    'ｧ',
    'ｨ',
    'ｩ',
    'ｪ',
    'ｫ',
    'ｬ',
    'ｭ',
    'ｮ',
    'ｯ',
    'ｰ',
  ];
  const zenkaku = [
    'ア',
    'イ',
    'ウ',
    'エ',
    'オ',
    'カ',
    'キ',
    'ク',
    'ケ',
    'コ',
    'サ',
    'シ',
    'ス',
    'セ',
    'ソ',
    'タ',
    'チ',
    'ツ',
    'テ',
    'ト',
    'ナ',
    'ニ',
    'ヌ',
    'ネ',
    'ノ',
    'ハ',
    'ヒ',
    'フ',
    'ヘ',
    'ホ',
    'マ',
    'ミ',
    'ム',
    'メ',
    'モ',
    'ヤ',
    'ユ',
    'ヨ',
    'ラ',
    'リ',
    'ル',
    'レ',
    'ロ',
    'ワ',
    'ヲ',
    'ン',
    'ァ',
    'ィ',
    'ゥ',
    'ェ',
    'ォ',
    'ャ',
    'ュ',
    'ョ',
    'ッ',
    'ー',
  ];

  String output = '';
  for (int i = 0; i < input.length; i++) {
    String c = input[i];
    int index = hankaku.indexOf(c);
    if (index != -1) {
      // 基本の置換
      output += zenkaku[index];
    } else if (c == 'ﾞ' && output.isNotEmpty) {
      // 濁点
      output = _addDakuten(output);
    } else if (c == 'ﾟ' && output.isNotEmpty) {
      // 半濁点
      output = _addHandakuten(output);
    } else {
      output += c;
    }
  }
  return output;
}

// 濁点付加
String _addDakuten(String str) {
  final last = str.substring(str.length - 1);
  const map = {
    'カ': 'ガ',
    'キ': 'ギ',
    'ク': 'グ',
    'ケ': 'ゲ',
    'コ': 'ゴ',
    'サ': 'ザ',
    'シ': 'ジ',
    'ス': 'ズ',
    'セ': 'ゼ',
    'ソ': 'ゾ',
    'タ': 'ダ',
    'チ': 'ヂ',
    'ツ': 'ヅ',
    'テ': 'デ',
    'ト': 'ド',
    'ハ': 'バ',
    'ヒ': 'ビ',
    'フ': 'ブ',
    'ヘ': 'ベ',
    'ホ': 'ボ',
    'ウ': 'ヴ',
  };
  return str.substring(0, str.length - 1) + (map[last] ?? last);
}

// 半濁点付加
String _addHandakuten(String str) {
  final last = str.substring(str.length - 1);
  const map = {'ハ': 'パ', 'ヒ': 'ピ', 'フ': 'プ', 'ヘ': 'ペ', 'ホ': 'ポ'};
  return str.substring(0, str.length - 1) + (map[last] ?? last);
}

Color getRegionColor(String pre) {
  if (pre.startsWith("北海道")) return Color.fromARGB(179, 142, 134, 212);

  final tohokus = ["青森", "岩手", "秋田", "宮城", "山形", "福島"];
  if (tohokus.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 106, 191, 204);
  }

  final kanto = ["茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川"];
  if (kanto.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 109, 189, 139);
  }

  final chubu = ["新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知"];
  if (chubu.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 153, 204, 105);
  }

  final kinki = ["三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山"];
  if (kinki.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 236, 173, 114);
  }

  final chugoku = ["鳥取", "島根", "岡山", "広島", "山口"];
  if (chugoku.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 197, 117, 221);
  }

  final shikoku = ["徳島", "香川", "愛媛", "高知"];
  if (shikoku.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 233, 130, 187);
  }

  final kyushu = ["福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄"];
  if (kyushu.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 236, 126, 126);
  }

  return Color.fromARGB(179, 128, 128, 128); // デフォルト
}

Color getBackRegionColor(String pre) {
  if (pre.startsWith("北海道")) return Color.fromARGB(179, 231, 231, 238);

  final tohokus = ["青森", "岩手", "秋田", "宮城", "山形", "福島"];
  if (tohokus.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 227, 232, 233);
  }

  final kanto = ["茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川"];
  if (kanto.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 226, 233, 228);
  }

  final chubu = ["新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知"];
  if (chubu.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 227, 231, 224);
  }

  final kinki = ["三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山"];
  if (kinki.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 236, 233, 230);
  }

  final chugoku = ["鳥取", "島根", "岡山", "広島", "山口"];
  if (chugoku.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 235, 229, 236);
  }

  final shikoku = ["徳島", "香川", "愛媛", "高知"];
  if (shikoku.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 231, 224, 228);
  }

  final kyushu = ["福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄"];
  if (kyushu.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(179, 233, 226, 226);
  }

  return Color.fromARGB(179, 230, 223, 223); // デフォルト
}

Color getFullRegionColor(String pre) {
  if (pre.startsWith("北海道")) return Color.fromARGB(255, 73, 58, 207);

  final tohokus = ["青森", "岩手", "秋田", "宮城", "山形", "福島"];
  if (tohokus.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(255, 61, 189, 209);
  }

  final kanto = ["茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川"];
  if (kanto.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(255, 46, 177, 96);
  }

  final chubu = ["新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知"];
  if (chubu.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(255, 130, 204, 60);
  }

  final kinki = ["三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山"];
  if (kinki.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(255, 233, 142, 58);
  }

  final chugoku = ["鳥取", "島根", "岡山", "広島", "山口"];
  if (chugoku.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(255, 183, 65, 219);
  }

  final shikoku = ["徳島", "香川", "愛媛", "高知"];
  if (shikoku.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(255, 228, 69, 156);
  }

  final kyushu = ["福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄"];
  if (kyushu.any((p) => pre.startsWith(p))) {
    return Color.fromARGB(255, 230, 58, 58);
  }

  return Color.fromARGB(179, 128, 128, 128); // デフォルト
}

Color getMarkerColor(String officialName) {
  if (officialName.contains("航空")) {
    return const Color.fromARGB(255, 3, 216, 244);
  }
  if (officialName.contains("気象台")) {
    return const Color.fromARGB(255, 244, 54, 127);
  }
  if (officialName.contains("アメダス")) {
    return const Color.fromARGB(255, 107, 175, 76);
  }
  return const Color.fromARGB(255, 255, 136, 0);
}

IconData geticon(String officialName) {
  if (officialName.contains("航空")) {
    return Icons.flight;
  }
  if (officialName.contains("気象台")) {
    return Icons.location_city;
  }
  if (officialName.contains("アメダス")) {
    return Icons.location_on;
  }
  return Icons.tour;
}

double colorToHue(Color color) {
  // RGB を HSV に変換
  final hsv = HSVColor.fromColor(color);
  return hsv.hue; // 0〜360 の Hue
}

Color getItemColor(String title) {
  switch (title) {
    case "平均気温":
    case "真夏日":
      return const Color.fromARGB(255, 243, 180, 85);
    case "平均最低気温":
      return const Color.fromARGB(255, 171, 92, 216);
    case "平均最高気温":
    case "猛暑日":
      return const Color.fromARGB(255, 243, 104, 95);
    case "年降水量":
    case "冬日":
      return const Color.fromARGB(255, 110, 122, 233);
    case "降水量\n100mm以上":
      return const Color.fromARGB(255, 26, 52, 221);
    case "降水量\n70mm以上":
      return const Color.fromARGB(255, 52, 78, 224);
    case "降水量\n50mm以上":
      return const Color.fromARGB(255, 79, 106, 223);
    case "降水量\n30mm以上":
      return const Color.fromARGB(255, 105, 130, 223);
    case "降水量\n10mm以上":
      return const Color.fromARGB(255, 130, 154, 219);
    case "降水量\n1mm以上":
      return const Color.fromARGB(255, 155, 180, 218);
    case "平均風速":
    case "熱帯夜":
      return const Color.fromARGB(255, 103, 185, 137);
    case "平均風速\n10m/s以上":
      return const Color.fromARGB(255, 149, 204, 172);
    case "平均風速\n15m/s以上":
      return const Color.fromARGB(255, 117, 202, 152);
    case "平均風速\n20m/s以上":
      return const Color.fromARGB(255, 78, 194, 126);
    case "平均風速\n30m/s以上":
      return const Color.fromARGB(255, 33, 196, 101);
    case "年日照時間":
    case "夏日":
      return const Color.fromARGB(255, 236, 221, 83);
    case "真冬日":
    case "年積雪量":
      return const Color.fromARGB(255, 163, 99, 189);
    case "積雪量\n100cm以上":
      return const Color.fromARGB(255, 153, 32, 201);
    case "積雪量\n50cm以上":
      return const Color.fromARGB(255, 161, 64, 199);
    case "積雪量\n20cm以上":
      return const Color.fromARGB(255, 172, 94, 202);
    case "積雪量\n10cm以上":
      return const Color.fromARGB(255, 182, 130, 202);
    case "積雪量\n5cm以上":
      return const Color.fromARGB(255, 181, 154, 190);
    case "年降雪量":
      return const Color.fromARGB(255, 115, 205, 228);
    case "降雪量\n50cm以上":
      return const Color.fromARGB(255, 48, 188, 223);
    case "降雪量\n20cm以上":
      return const Color.fromARGB(255, 73, 190, 219);
    case "降雪量\n10cm以上":
      return const Color.fromARGB(255, 104, 198, 221);
    case "降雪量\n5cm以上":
      return const Color.fromARGB(255, 129, 201, 219);
    case "降雪量\n3cm以上":
      return const Color.fromARGB(255, 155, 208, 223);
    default:
      return const Color.fromARGB(255, 175, 175, 175); // デフォルト色
  }
}

final List<String> prefectureOrder = [
  "北海道",
  "青森県",
  "岩手県",
  "宮城県",
  "秋田県",
  "山形県",
  "福島県",
  "茨城県",
  "栃木県",
  "群馬県",
  "埼玉県",
  "千葉県",
  "東京都",
  "神奈川県",
  "新潟県",
  "富山県",
  "石川県",
  "福井県",
  "山梨県",
  "長野県",
  "岐阜県",
  "静岡県",
  "愛知県",
  "三重県",
  "滋賀県",
  "京都府",
  "大阪府",
  "兵庫県",
  "奈良県",
  "和歌山県",
  "鳥取県",
  "島根県",
  "岡山県",
  "広島県",
  "山口県",
  "徳島県",
  "香川県",
  "愛媛県",
  "高知県",
  "福岡県",
  "佐賀県",
  "長崎県",
  "熊本県",
  "大分県",
  "宮崎県",
  "鹿児島県",
  "沖縄県",
];
