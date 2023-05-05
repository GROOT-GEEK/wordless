import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'letter.dart';
import 'db.dart';

List<String> get keyboardRows => ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
Database db = Database();

class GameState extends ChangeNotifier {
  GameState() {
    word = "Juego";
  }

  static const int tries = 6;
  late String word;

  List<String> guesses = [];
  String currentGuess = "";
  bool isFinished = false;
  Set<String> usedLetters = <String>{};
  Set<String> usedMatched = <String>{};
  Set<String> usedMatchedPosition = <String>{};

  Set<String> events = <String>{};
  List<String> messages = [];
  bool isAnimating = false;

  List<LetterState> validateWord(String guess) {
    var g = guess.split('').toList();
    if (guess.isEmpty) {
      return word.split('').map<LetterState>((e) => LetterState.none).toList();
    }
    // by default missed
    List<LetterState> result =
        word.split('').map<LetterState>((e) => LetterState.missed).toList();

    var idx = 0;
    // Match those in the expected position
    for (var c in g) {
      if (c == word[idx]) {
        result[idx] = LetterState.positionMatch;
        // set to something which is not a letter
        // to avoid remarking as yellow below
        g[idx] = '0';
      }
      idx++;
    }
    // match those who are not in the expected position but exist
    idx = 0;
    for (var c in result) {
      if (c != LetterState.positionMatch) {
        var guessIdx = 0;
        for (var l in g) {
          if (word[idx] == l) {
            result[guessIdx] = LetterState.match;
            g[guessIdx] = '0';
            // stop checking for the same letter if we found one
            break;
          }
          guessIdx++;
        }
      }
      idx++;
    }

    return result;
  }

  exists(word) {
    return "juego"; //validar si el diccionario contiene la palabra
  }

  clearEvent(String event) {
    events.remove(event);
  }

  startAnimation(int seconds) {
    isAnimating = true;
    Future.delayed(Duration(seconds: seconds), () {
      isAnimating = false;
      notifyListeners();
    });
  }

  addEvent(String event) {
    events.add(event);
  }

  updateCurrentGuess(String text) {
    if (isFinished || isAnimating) {
      return;
    }
    if (text == "enter") {
      if (currentGuess.length < word.length) {
        Toast.show("Muy corta", duration: Toast.lengthLong, gravity: Toast.top);
        addEvent("SHAKE-CURRENT");
        startAnimation(2);
        notifyListeners();
        return;
      } else {
        addGuess();
      }
    } else if (text == "delete") {
      if (currentGuess.isNotEmpty) {
        currentGuess = currentGuess.substring(0, currentGuess.length - 1);
      }
      notifyListeners();
    } else if (currentGuess.length < word.length &&
        keyboardRows.indexWhere((element) => element.contains(text)) >= 0) {
      currentGuess += text;
      notifyListeners();
    }
  }

  addGuess() {
    if (isAnimating) {
      return;
    }

    if (exists(currentGuess)) {
      guesses.add(currentGuess);
      var lstate = validateWord(currentGuess);
      var idx = 0;
      var won = true;
      while (idx < lstate.length) {
        if (lstate[idx] == LetterState.positionMatch) {
          usedMatchedPosition.add(currentGuess[idx]);
        } else if (lstate[idx] == LetterState.match) {
          usedMatched.add(currentGuess[idx]);
          won = false;
        } else {
          usedLetters.add(currentGuess[idx]);
          won = false;
        }
        idx++;
      }

      if (won || guesses.length == GameState.tries) {
        Toast.show(won ? "FANTASTICO!" : word.toUpperCase(),
            duration: Toast.lengthLong, gravity: Toast.top);

        db.updateGame(guesses.length, won);
        isFinished = true;
      }
      currentGuess = "";
      addEvent("ROTATE-PREV");
      startAnimation(4);
    } else {
      Toast.show("No existe en el diccionario",
          duration: Toast.lengthLong, gravity: Toast.top);
      addEvent("SHAKE-CURRENT");
      startAnimation(1);
    }

    notifyListeners();
  }
}
