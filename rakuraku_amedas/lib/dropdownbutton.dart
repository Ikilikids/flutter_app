import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// タイトル部分のクラス
class TitleItem {
  final String label;
  final Color backgroundColor;

  TitleItem(this.label, this.backgroundColor);
}

/// 都道府県リスト (タイトル行と県名を混在させる)
final List<dynamic> prefectureList = [
  TitleItem('★全地域', Colors.grey),
  "全国",
  "島を除く",
  "島嶼部",
  TitleItem('★地方別', Colors.grey),
  "東北地方",
  "関東地方",
  "中部地方",
  "近畿地方",
  "中国地方",
  "四国地方",
  "九州地方",
  TitleItem('★都道府県', Colors.grey),
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

final List<dynamic> prefectureList2 = [
  TitleItem('★全地域', Colors.grey),
  "全国",
  TitleItem('★地方別', Colors.grey),
  "東北地方",
  "関東地方",
  "中部地方",
  "近畿地方",
  "中国地方",
  "四国地方",
  "九州地方",
  TitleItem('★都道府県', Colors.grey),
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

// 選択中の都道府県（String?で管理）
String? selectedPrefecture = prefectureList.whereType<String>().first;

/// 都道府県アイテム
DropdownMenuItem<String> selectItem(String name) {
  return DropdownMenuItem<String>(
    value: name,
    child: Container(
      margin: EdgeInsets.only(left: 15.w), // 隙間入れる
      child: Text(name, style: TextStyle(fontSize: min(15, 15.sp))),
    ),
  );
}

/// タイトルアイテム
DropdownMenuItem<String> titleItem(TitleItem titleItem) {
  return DropdownMenuItem<String>(
    value: null, // 選択値にはならない
    enabled: false, // 押下不可
    child: Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 30.h), // やや小
      color: titleItem.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      child: Text(
        titleItem.label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: min(18, 18.sp),
        ),
      ),
    ),
  );
}
