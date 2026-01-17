import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/assistance/firebase_score.dart';

Future<void> multiplyAllScores() async {
  final firestore = FirebaseFirestore.instance;

  // 🔴 明示的に指定（ここが全て）
  final quizTitles = [
    '色で反応',
    '数字で反応',
    'マス目で反応',
    // 実在する quizTitle を全部書く
  ];

  final rankingModes = ['rankings_t', 'rankings_g'];

  final now = DateTime.now();
  final monthKey = "${now.year}-${now.month}";
  final weekKey = "${now.year}-${getWeekNumber(now)}";

  final periods = [
    'alltime',
    'monthly-$monthKey',
    'weekly-$weekKey',
  ];

  for (final ranking in rankingModes) {
    for (final quizTitle in quizTitles) {
      for (final period in periods) {
        final col =
            firestore.collection(ranking).doc(quizTitle).collection(period);

        final snap = await col.get();

        if (snap.docs.isEmpty) {
          continue;
        }

        for (final doc in snap.docs) {
          final oldScore = (doc.data()['score'] as num?)?.toDouble() ?? 0.0;
          final newScore = oldScore * 1000;

          await doc.reference.update({'score': newScore});
        }
      }
    }
  }
}
