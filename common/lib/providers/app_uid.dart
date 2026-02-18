import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_uid.g.dart';

@riverpod
class AppUid extends _$AppUid {
  @override
  Future<String> build() async {
    // 🔹 匿名ログイン
    final userCred = await FirebaseAuth.instance.signInAnonymously();
    final uid = userCred.user?.uid;

    if (uid == null) {
      throw Exception('UID取得失敗');
    }

    // 🔹 Firestore にユーザーレコード作成
    await _createUserRecord(uid);

    return uid;
  }

  /// ユーザードキュメント作成（初回のみ）
  Future<void> _createUserRecord(String uid) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// ユーザー名取得
  Future<String> loadUsername(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!doc.exists) return '名無し';

    final data = doc.data();
    final userName = data?['userName'];

    return userName is String ? userName : '名無し';
  }
}
