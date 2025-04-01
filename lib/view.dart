import 'package:flutter/material.dart';
import 'model.dart';
import 'viewmodel.dart'; // Importando o ViewModel

class CronometroPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  CronometroPage({required this.toggleTheme});

  @override
  _CronometroPageState createState() => _CronometroPageState();
}

class _CronometroPageState extends State<CronometroPage> {
  late CronometroViewModel _viewModel;
  bool isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _viewModel = CronometroViewModel(CronometroModel());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cronômetro de Voltas'),
          backgroundColor: Colors.deepPurpleAccent,
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
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
                      value: (_viewModel.model.milliseconds % 60000) / 60000,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade800,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        _viewModel.model.formatTime(_viewModel.model.milliseconds),
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _viewModel.model.isRunning ? "Cronômetro em execução" : "Cronômetro pausado",
                        style: TextStyle(fontSize: 16, color: Colors.deepPurpleAccent),
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
                      onPressed: () {
                        setState(() {
                          _viewModel.lap();
                        });
                      },
                      child: Text("Marcar Volta"),
                    ),
                    SizedBox(height: 5),
                    _viewModel.lastSpokenText.contains("Volta") ? Text("Salvar tempo da volta") : SizedBox(),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _viewModel.startStop();
                        });
                      },
                      child: Text(_viewModel.model.isRunning ? "Pausar" : "Iniciar"),
                    ),
                    SizedBox(height: 5),
                    _viewModel.lastSpokenText.contains("Cronômetro") ? Text("Iniciar ou pausar o cronômetro") : SizedBox(),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _viewModel.reset();
                        });
                      },
                      child: Text("Reiniciar"),
                    ),
                    SizedBox(height: 5),
                    _viewModel.lastSpokenText.contains("reiniciado") ? Text("Zerar tempo") : SizedBox(),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _viewModel.model.laps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Volta ${_viewModel.model.laps.length - index}"),
                    subtitle: Text(_viewModel.model.laps[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
