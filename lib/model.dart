class CronometroModel {
  int milliseconds = 0;
  bool isRunning = false;
  List<String> laps = [];

  void start() {
    isRunning = true;
  }

  void stop() {
    isRunning = false;
  }

  void reset() {
    milliseconds = 0;
    isRunning = false;
    laps.clear();
  }

  void lap() {
    laps.insert(0, formatTime(milliseconds));
  }

  String formatTime(int milliseconds) {
    int centiseconds = (milliseconds ~/ 10) % 100;
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = (milliseconds ~/ 60000) % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')},${centiseconds.toString().padLeft(2, '0')}";
  }
}
