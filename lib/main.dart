import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shulestudent/StartScreen.dart';
import 'package:shulestudent/database/DataBase.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? group = prefs.getString('selectedGroup');

  Widget initialScreen;

  if (group != null) {
    initialScreen = Main(group);
  } else {
    initialScreen = StartScreen();
  }
  runApp(MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: initialScreen));
}

class Main extends StatefulWidget {
  final String? group;
  const Main(this.group);


  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  ThemeMode _themeMode = ThemeMode.system;
  final DatabaseHelper db = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

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
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.menu)),
                Tab(icon: Icon(Icons.menu_book)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text('Расписание для группы:\n${widget.group}'),
          ),
          body: TabBarView(
            children: [
              Center(
                child: TextButton(
                  child: const Text(
                    'Нажмите чтобы сменить группу',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Scaffold(
                  body: FutureBuilder<List<Map<String, dynamic>>>(
                    future: db.loadData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          var item = snapshot.data?[index];
                          if (item != null){
                            return ListTile(
                              title: Text(item['title'] ?? ''),
                              subtitle: Text(item['subtitle'] ?? ''),
                            );
                          }
                          else{
                            return SizedBox.shrink();
                          }
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                )
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Выберите тему:'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _themeMode = ThemeMode.light;
                        });
                        _saveThemeMode(_themeMode);
                      },
                      child: const Text('Светлая'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _themeMode = ThemeMode.dark;
                        });
                        _saveThemeMode(_themeMode);
                      },
                      child: const Text('Темная'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _themeMode = ThemeMode.system;
                        });
                        _saveThemeMode(_themeMode);
                      },
                      child: const Text('Как в системе'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class DataBaseScreen extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           body: FutureBuilder<List<Map<String, dynamic>>>(
//             future: db.loadData(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data != null) {
//                 return ListView.builder(
//                   itemCount: snapshot.data?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     var item = snapshot.data?[index];
//                     if (item != null){
//                       return ListTile(
//                         title: Text(item['title'] ?? ''),
//                         subtitle: Text(item['subtitle'] ?? ''),
//                       );
//                     }
//                     else{
//                       return SizedBox.shrink();
//                     }
//                   },
//                 );
//               } else if (snapshot.hasError) {
//                 return Text("${snapshot.error}");
//               }
//               return CircularProgressIndicator();
//             },
//           )
//       ),
//     );
//   }
// }
