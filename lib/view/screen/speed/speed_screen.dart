import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukol_skola_2/view/screen/speed/speed_history_screen.dart';

class SpeedScreen extends StatefulWidget {
  const SpeedScreen({super.key});

  @override
  State<SpeedScreen> createState() => _SpeedScreenState();
}

class _SpeedScreenState extends State<SpeedScreen> {
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _mController = TextEditingController();
  final TextEditingController _hController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _sController = TextEditingController();
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
      _history = prefs.getStringList('speed_history') ?? [];
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('speed_km', _kmController.text);
    await prefs.setString('speed_m', _mController.text);
    await prefs.setString('speed_h', _hController.text);
    await prefs.setString('speed_min', _minController.text);
    await prefs.setString('speed_s', _sController.text);
    await prefs.setString('speed_result', _result);
    await prefs.setStringList('speed_history', _history);
  }

  void _calculateSpeed() {
    final double km = double.tryParse(_kmController.text) ?? 0;
    final double m = double.tryParse(_mController.text) ?? 0;
    final double h = double.tryParse(_hController.text) ?? 0;
    final double min = double.tryParse(_minController.text) ?? 0;
    final double s = double.tryParse(_sController.text) ?? 0;

    final double totalDistanceKm = km + (m / 1000);
    final double totalTimeHours = h + (min / 60) + (s / 3600);

    if (totalTimeHours == 0) {
      setState(() {
        _result = 'Chyba: Čas nemůže být nula';
      });
      _saveState();
      return;
    }

    double speed = totalDistanceKm / totalTimeHours;
    final historyEntry =
        '${totalDistanceKm.toStringAsFixed(2)} km / ${totalTimeHours.toStringAsFixed(2)} h = ${speed.toStringAsFixed(2)} km/h';

    if (_history.length >= 15) {
      _history.removeAt(0);
    }
    _history.add(historyEntry);

    setState(() {
      _result = speed.toStringAsFixed(2);
    });
    _saveState();
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SpeedHistoryScreen(history: _history),
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
          title: const Text('Výpočet Rychlosti'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: _openHistory,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Vzdálenost',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _kmController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Kilometry'),
                      onChanged: (_) => _saveInput(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _mController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Metry'),
                      onChanged: (_) => _saveInput(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Čas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      decoration: const InputDecoration(labelText: 'Hodiny'),
                      onChanged: (_) => _saveInput(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _minController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      decoration: const InputDecoration(labelText: 'Minuty'),
                      onChanged: (_) => _saveInput(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _sController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Vteřiny'),
                      onChanged: (_) => _saveInput(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateSpeed,
                child: const Text('Vypočítat rychlost'),
              ),
              const SizedBox(height: 24),
              Text(
                'Průměrná rychlost: $_result km/h',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveInput() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('speed_km', _kmController.text);
    await prefs.setString('speed_m', _mController.text);
    await prefs.setString('speed_h', _hController.text);
    await prefs.setString('speed_min', _minController.text);
    await prefs.setString('speed_s', _sController.text);
  }

  @override
  void dispose() {
    _kmController.dispose();
    _mController.dispose();
    _hController.dispose();
    _minController.dispose();
    _sController.dispose();
    super.dispose();
  }
}

