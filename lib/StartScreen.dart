import 'package:flutter/material.dart';
import 'package:shulestudent/database/DataBase.dart';
import 'package:flutter/services.dart';
import 'package:shulestudent/main.dart';
import 'package:sqflite_common/sqlite_api.dart';

class StartScreen extends StatefulWidget {
  final String? group;
  late DatabaseManager dbManager;

  StartScreen(this.group) {
    dbManager = DatabaseManager();
  }

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
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
                'АТ 21-11',
                'АТ 22-11',
                'АТ 23-11',
                'ДО 21-11-1',
                'ДО 21-11-2',
                'ДО 22-11-1',
                'ДО 22-11-2',
                'ДО 23-11-1',
                'ДО 23-11-2',
                'ДО 23-11-3',
                'ИБАС 21-11',
                'ИБАС 22-11',
                'ИБАС 23-11-1',
                'ИБАС 23-11-2',
                'ИСПИ 21-11-1',
                'ИСПИ 21-11-2',
                'ИСПИ 21-11-3',
                'ИСПИ 22-11-1',
                'ИСПИ 22-11-2',
                'ИСПИ 22-11-3',
                'ИСПИ 23-11-1',
                'ИСПИ 23-11-2',
                'КП 21-11-1',
                'КП 21-11-2',
                'КП 21-11-3',
                'КП 22-11-1',
                'КП 22-11-2',
                'КП 22-11-3',
                'КП 22-11-4',
                'КП 23-11-1',
                'КП 23-11-2',
                'КП 23-11-3',
                'КП 23-11-4',
                'ОСАТПиП 21-11',
                'ОСАТПиП 22-11',
                'ОСАТПиП 23-11-1',
                'ОСАТПиП 23-11-2',
                'ПДО ТТ 21-11',
                'ПДО ТТ 22-11',
                'ПДО ТТ 23-11',
                'ССА 21-11-1',
                'ССА 21-11-2',
                'ССА 21-11-3',
                'ССА 22-11-1',
                'ССА 22-11-2',
                'ССА 23-11',
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
                  widget.dbManager.tableName = _selectedGroup!;
                  await widget.dbManager.loadDatabase();
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
    );
  }
}

void main() => runApp(MaterialApp(home: StartScreen(null)));
