import 'package:flutter/material.dart';
import 'package:shulestudent/database/DataBase.dart';
import 'package:flutter/services.dart';
import 'package:shulestudent/main.dart';
import 'package:sqflite_common/sqlite_api.dart';

class StartScreen extends StatefulWidget {

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String? _selectedGroup;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Расписание студента',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Добро пожаловать!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const Text('Выберите группу: '),
              DropdownButton<String>(
                value: _selectedGroup,
                items: <String>[
                  'ИСИП 21-11-1',
                  'ИСИП 21-11-2',
                  'ИСИП 21-11-3',
                  'ИСИП 22-11-1',
                  'ИСИП 22-11-2',
                  'ИСИП 22-11-3',
                  'ИСИП 23-11-1',
                  'ИСИП 23-11-2',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text("Выберите группу"),
                onChanged: (String? value) {
                  setState(() {
                    _selectedGroup = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedGroup != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Main(_selectedGroup)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Вы ничего не выбрали.'),
                      ),
                    );
                  }
                },
                child: const Text('Начать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: StartScreen()));
