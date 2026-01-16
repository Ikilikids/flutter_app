import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createUserRecord(String uid) async {
  final ref = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await ref.get();
  if (!snapshot.exists) {
    await ref.set({'createdAt': FieldValue.serverTimestamp()});
  }
}
