import 'package:flutter/material.dart';
import 'view/screen/calculator/calculator_screen.dart';
import 'view/screen/notes/notes_screen.dart';
import 'view/screen/about/about_screen.dart';
import 'view/screen/speed/speed_screen.dart';
import 'data/notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: darkModeNotifier, builder: (context, value, child) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: (value) ? Brightness.dark : Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CalculatorScreen(),
    NotesScreen(),
    SpeedScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulačka',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Poznámky',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Rychlost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'O aplikaci',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
