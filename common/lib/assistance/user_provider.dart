import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? uid;
  String userName = '名無し';

  void setUid(String? uid) {
    this.uid = uid;
  }

  Future<void> load() async {
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    userName = doc.data()?['userName'] ?? '名無し';
    notifyListeners();
  }
}
