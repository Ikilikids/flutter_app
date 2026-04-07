import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart' show PeriodType;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../bootstrap.dart';

part 'app_uid.g.dart';

// ---------------------------------------------------------
// 1. UIDを取得するProvider (一回取ったら不変)
// ---------------------------------------------------------
@Riverpod(keepAlive: true)
Future<String> appUid(Ref ref) async {
  final userCred = await FirebaseAuth.instance.signInAnonymously();
  return userCred.user?.uid ?? "404";
}

// ---------------------------------------------------------
// 2. ユーザー名を管理する司令塔 (取得・保持・更新をこれ1つで)
// ---------------------------------------------------------
@Riverpod(keepAlive: true)
class AppUserName extends _$AppUserName {
  @override
  Future<String> build() async {
    // A. まずUIDが取れるのを待つ
    final uid = await ref.watch(appUidProvider.future);

    // B. そのUIDを使って名前をFirestoreから持ってくる
    return await _fetchOrCreateUser(uid);
  }

  /// 名前を更新し、各所を一括で書き換える
  Future<void> updateName(String newName) async {
    // 起動時にロード済みなら、UIDは requireValue で同期的に取れる
    final uid = ref.read(appUidProvider).requireValue;
    final firestore = FirebaseFirestore.instance;

    // guardを使うことで、処理中のエラーハンドリングと状態更新を同時に行う
    state = await AsyncValue.guard(() async {
      // 1. users2 ドキュメントの更新
      await firestore.collection("users2").doc(uid).set({
        "userName": newName,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 2. ランキングの一括更新（バックグラウンド）
      _updateAllRankings(uid, newName);

      return newName; // これが新しい state になる
    });
  }

  /// ランキング更新ロジック（内部メソッド）
  Future<void> _updateAllRankings(String uid, String newName) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    // ※ allDataなどは定義されている前提
    final rankLabels = allData.mid
        .expand((g) => g.detail)
        .map((d) => d.resisterOrigin)
        .toSet()
        .toList();
    rankLabels.add("全合計");

    final modeTypes = ['t', 'g'];

    for (var rType in rankLabels) {
      for (var mType in modeTypes) {
        for (var type in PeriodType.values) {
          final docRef = firestore
              .collection("rankings_v5")
              .doc("${rType}_${mType}_${type.value}")
              .collection("users")
              .doc(uid);

          batch.set(docRef, {"userName": newName}, SetOptions(merge: true));
        }
      }
    }
    await batch.commit();
  }
}

// ---------------------------------------------------------
// 内部用ヘルパー（Firestore操作）
// ---------------------------------------------------------
Future<String> _fetchOrCreateUser(String uid) async {
  final docRef = FirebaseFirestore.instance.collection('users2').doc(uid);
  final snapshot = await docRef.get();

  if (!snapshot.exists) {
    await docRef.set({'createdAt': FieldValue.serverTimestamp()});
    return '名無し';
  }

  final data = snapshot.data();
  return data?['userName'] as String? ?? '名無し';
}
