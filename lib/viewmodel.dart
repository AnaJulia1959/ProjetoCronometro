import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'model.dart';

class CronometroViewModel {
  final CronometroModel model;
  final FlutterTts flutterTts = FlutterTts();
  String lastSpokenText = "";
  Timer? _timer;

  CronometroViewModel(this.model);

  void startStop() {
    if (model.isRunning) {
      model.stop();
      _timer?.cancel();
      _speak("Cronômetro pausado");
    } else {
      model.start();
      _startTimer();
      _speak("Cronômetro iniciado");
    }
  }

  void reset() {
    model.reset();
    _timer?.cancel();
    _speak("Cronômetro reiniciado");
  }

  void lap() {
    model.lap();
    _speak("Volta ${model.laps.length}: ${model.formatTime(model.milliseconds)}");
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      model.incrementTime();
    });
  }

  void _speak(String text) async {
    lastSpokenText = text;
    await flutterTts.speak(text);
  }
}
