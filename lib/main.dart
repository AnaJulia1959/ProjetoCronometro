import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

void main() {
  runApp(CronometroApp());
}

class CronometroApp extends StatefulWidget {
  @override
  _CronometroAppState createState() => _CronometroAppState();
}

class _CronometroAppState extends State<CronometroApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: CronometroPage(toggleTheme: () {
        setState(() {
          isDarkMode = !isDarkMode;
        });
      }),
    );
  }
}

class CronometroPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  CronometroPage({required this.toggleTheme});

  @override
  _CronometroPageState createState() => _CronometroPageState();
}

class _CronometroPageState extends State<CronometroPage> {
  late Timer _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  List<String> _laps = [];
  FlutterTts flutterTts = FlutterTts();
  String _lastSpokenText = "";

  void _startStop() {
    if (_isRunning) {
      _timer.cancel();
      _speak("Cronômetro pausado");
    } else {
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _milliseconds += 10;
        });
      });
      _speak("Cronômetro iniciado");
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _reset() {
    _timer.cancel();
    setState(() {
      _milliseconds = 0;
      _isRunning = false;
      _laps.clear();
    });
    _speak("Cronômetro reiniciado");
  }

  void _lap() {
    setState(() {
      _laps.insert(0, _formatTime(_milliseconds));
    });
    _speak("Volta ${_laps.length}: ${_formatTime(_milliseconds)}");
  }

  void _speak(String text) async {
    setState(() {
      _lastSpokenText = text;
    });
    await flutterTts.speak(text);
  }

  String _formatTime(int milliseconds) {
    int centiseconds = (milliseconds ~/ 10) % 100;
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = (milliseconds ~/ 60000) % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')},${centiseconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronômetro de Voltas'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: (_milliseconds % 60000) / 60000,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade800,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _formatTime(_milliseconds),
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _isRunning ? "Cronômetro em execução" : "Cronômetro pausado",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Certifique-se de que o volume está ativo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _lap,
                    child: Text("Marcar Volta"),
                  ),
                  SizedBox(height: 5),
                  _lastSpokenText.contains("Volta") ? Text("Salvar tempo da volta") : SizedBox(),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _startStop,
                    child: Text(_isRunning ? "Pausar" : "Iniciar"),
                  ),
                  SizedBox(height: 5),
                  _lastSpokenText.contains("Cronômetro") ? Text("Iniciar ou pausar o cronômetro") : SizedBox(),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _reset,
                    child: Text("Reiniciar"),
                  ),
                  SizedBox(height: 5),
                  _lastSpokenText.contains("reiniciado") ? Text("Zerar tempo") : SizedBox(),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Volta ${_laps.length - index}"),
                  subtitle: Text(_laps[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}