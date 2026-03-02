import 'dart:math';
import 'package:flutter/services.dart';

class OriginCentral {
  String mainsort;
  static List<List<String>>? _csvData;

  OriginCentral({required this.mainsort});

  static Future<void> loadCSV() async {
    if (_csvData != null) return;
    try {
      final String response = await rootBundle.loadString('assets/csv/eng_data.csv');
      final List<String> lines = response.split('\n');
      _csvData = [];
      for (String line in lines) {
        String trimmedLine = line.trim();
        if (trimmedLine.isEmpty) continue;
        List<String> parts = trimmedLine.split(',').map((e) => e.trim()).toList();
        if (parts.length >= 3) {
          _csvData!.add(parts);
        }
      }
    } catch (e) {
      print("Error loading CSV: $e");
      _csvData = [];
    }
  }

  Map<String, dynamic> makingvariable() {
    if (_csvData == null || _csvData!.isEmpty) {
      return {
        "question1": "No Data",
        "all1": "",
        "fi1": mainsort,
        "letters": [],
      };
    }

    final random = Random();
    final entry = _csvData![random.nextInt(_csvData!.length)];
    
    // word is 1st column (index 0), meaning is 3rd column (index 2)
    String word = entry[0];
    String meaning = entry[2];

    // Generate letters for buttons
    List<String> letters = word.split('');
    // Add 2 random letters
    const alphabet = 'abcdefghijklmnopqrstuvwxyz';
    for (int i = 0; i < 2; i++) {
      String randomLetter;
      do {
        randomLetter = alphabet[random.nextInt(alphabet.length)];
      } while (letters.contains(randomLetter));
      letters.add(randomLetter);
    }
    letters.shuffle(random);

    Map<String, dynamic> result = {};
    result["fi1"] = mainsort;
    result["question1"] = meaning;
    result["all1"] = word;
    result["letters"] = letters;

    return result;
  }
}
