import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/page/commmon_quiz.dart';
import 'package:flutter_application_4/page/quiz_screen_j.dart';
import 'package:provider/provider.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late List quizinfo;
  late QuizStateProvider quizState;
  int _countdown = 4;
  bool _isLoaded = false;

  List<Map<String, String>> chosedData = [];
  Map<String, dynamic> numberData = {};
  late SoundManager soundManager;
  @override
  void initState() {
    super.initState();
    _initAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    soundManager = Provider.of<SoundManager>(context, listen: false);
    quizState = Provider.of<QuizStateProvider>(context, listen: false);
    quizinfo = quizState.quizinfo;
  }

  Future<void> _initAll() async {
    await loadChooseFile();
    _isLoaded = true;
    _startCountdown();
  }

  Future<void> loadChooseFile() async {
    final chooseString =
        await rootBundle.loadString("assets/csv/choosesort.csv");
    List<List<dynamic>> choseds =
        const CsvToListConverter().convert(chooseString);
    if (choseds.isNotEmpty) {
      for (var chosed in choseds) {
        if (quizinfo[3] == "notime") {
          if ((quizinfo[0].contains(chosed[0].toString()) ||
                  chosed[0].toString().contains(quizinfo[0])) &&
              chosed[1].toString().contains(quizinfo[1]) &&
              chosed[2].toString() == (quizinfo[2])) {
            chosedData.add(
              {
                "123abc": chosed[0].toString(),
                "main": chosed[1].toString(),
                "sub": chosed[2].toString(),
              },
            );
          }
        } else {
          if ((quizinfo[0].contains(chosed[0].toString()) ||
              chosed[0].toString().contains(quizinfo[0]))) {
            chosedData.add(
              {
                "123abc": chosed[0].toString(),
                "main": chosed[1].toString(),
                "sub": chosed[2].toString(),
              },
            );
          }
        }
      }
    }
  }

  void _startCountdown() {
    if (_countdown > 1) {
      soundManager.playSound('countdown1.mp3');
      setState(() {
        _countdown--;
      });

      Future.delayed(const Duration(seconds: 1), _startCountdown);
    } else {
      soundManager.playSound('countdown2.mp3');
      if (quizinfo[3] == "time") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Quizscreen(
              numberData: numberData,
              chosedData: chosedData,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => Quizscreen(
              numberData: numberData,
              chosedData: chosedData,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 条件に応じて true/false
      child: Scaffold(
        body: Center(
          child: !_isLoaded
              ? const CircularProgressIndicator()
              : Text(
                  '$_countdown',
                  style: const TextStyle(
                      fontSize: 200, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
