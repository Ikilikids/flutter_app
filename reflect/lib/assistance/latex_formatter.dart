class LatexQuizFormatter {
  final Map<String, dynamic> calculatedresult;

  LatexQuizFormatter({required this.calculatedresult});

  Map<String, dynamic> deta() {
    String question = calculatedresult['question1'] as String;
    String answerString = calculatedresult['all1'] as String;

    // Replace the last '？' with '◯' for the display question.
    // This is a simple assumption, but should cover the cases.
    String latexQuestion = question.replaceFirst(RegExp(r'？$'), '◯');

    // Split the answer into individual characters for digit-by-digit validation.
    // The required format is List<List<String>>.
    List<List<String>> answerList = [
      answerString.split(''),
      [],
      [],
      [],
    ];

    return {
      'alist': answerList,
      'latex': latexQuestion,
    };
  }
}
