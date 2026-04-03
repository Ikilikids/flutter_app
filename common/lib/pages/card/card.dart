import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonDetailCard extends HookConsumerWidget {
  final int modeIndex;
  const CommonDetailCard({super.key, required this.modeIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (modeIndex >= allData.mid.length) {
      return const Scaffold(body: Center(child: Text("モードが見つかりません")));
    }

    // ★ Provider を介さず、不変の原本（_appConfig）を直接参照
    final masterMid = allData.mid[modeIndex];

    return ListView.builder(
      itemCount: masterMid.detail.length,
      itemBuilder: (context, index) {
        final quizId = masterMid.detail[index].quizId;

        return SizedBox(
          height: 200,
          child: _CommonSubjectCard(
            quizId: quizId,
          ),
        );
      },
    );
  }
}

class _CommonSubjectCard extends HookConsumerWidget {
  final QuizId quizId;

  const _CommonSubjectCard({
    required this.quizId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ★ 自分のIDの成績が変わった時だけ、このカード1枚が描き変わる！
    final detailConfig = ref.watch(quizDetailProvider(quizId));
    final detail = detailConfig.detail;
    final mode = detailConfig.modeData;

    final mainColor = getQuizColor2(detail.color, context, 0.7, 0.55, 0.95);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor1(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mainColor, width: 2),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleIcon(quizId: quizId),
                  CardTitle(quizId: quizId),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  ScoreDisplay(quizId: quizId),
                  if (mode.isbattle)
                    PlayButton(
                      quizId: quizId,
                    )
                  else ...[
                    PlayButton(
                      quizId: quizId,
                      qcount: 5,
                    ),
                    PlayButton(
                      quizId: quizId,
                      qcount: 10,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
