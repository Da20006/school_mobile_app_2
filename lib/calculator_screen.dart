import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukol_skola_2/calculator_history_screen.dart';
import './notifier.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  String _result = '0';
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('calculator_history') ?? [];
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('calculator_history', _history);
  }

  void _calculate(String operation) {
    final double? a = double.tryParse(_controllerA.text);
    final double? b = double.tryParse(_controllerB.text);

    if (a == null || b == null) {
      setState(() {
        _result = 'Chyba: Neplatný vstup';
      });
      _saveState();
      return;
    }

    double res;
    switch (operation) {
      case '+':
        res = a + b;
        break;
      case '-':
        res = a - b;
        break;
      case '*':
        res = a * b;
        break;
      case '/':
        if (b == 0) {
          setState(() {
            _result = 'Chyba: Dělení nulou';
          });
          _saveState();
          return;
        }
        res = a / b;
        break;
      default:
        res = 0;
    }

    final newHistoryItem = '${_controllerA.text} $operation ${_controllerB.text} = ${res.toString()}';
    if (_history.length >= 15) {
      _history.removeAt(0);
    }
    _history.add(newHistoryItem);

    setState(() {
      _result = res.toString();
    });
    _saveState();
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalculatorHistoryScreen(history: _history),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kalkulačka'),
          actions: [
            ValueListenableBuilder(valueListenable: darkModeNotifier, builder: (context, value, child) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'open_disk') {
                    _openHistory();
                  } else if (value == 'toggle_light') {
                    darkModeNotifier.value = !darkModeNotifier.value;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Přepnuto na ${darkModeNotifier.value ? 'dark' : 'light'} mode')),
                    );
                    // Actual theme toggling should be implemented at app level (e.g. via Provider, InheritedWidget or passing a callback).
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'open_disk',
                    child: ListTile(
                      leading: Icon(Icons.history),
                      title: Text('Otevřít historii'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'toggle_light',
                    child: ListTile(
                      leading: Icon(Icons.light_mode),
                      title: Text('Přepnout light mode'),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controllerA,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Číslo A',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controllerB,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Číslo B',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () => _calculate('+'), child: const Text('+')),
                  ElevatedButton(
                      onPressed: () => _calculate('-'), child: const Text('-')),
                  ElevatedButton(
                      onPressed: () => _calculate('*'), child: const Text('*')),
                  ElevatedButton(
                      onPressed: () => _calculate('/'), child: const Text('/')),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Výsledek: $_result',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    _controllerA.dispose();
    _controllerB.dispose();
    super.dispose();
  }
}
