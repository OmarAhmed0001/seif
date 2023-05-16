// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_barometer/flutter_barometer.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double minPress = 0.0;
  double maxPress = 0.0;

  Future<void> MeasureMaxPress() async {
    bool pressureFound = false;

    while (!pressureFound) {
      final event = await flutterBarometerEvents.first;
      if (event.pressure != null) {
        setState(() {
          maxPress = event.pressure;
        });
        pressureFound = true;
      }
    }
  }

  Future<void> MeasureMinPress() async {
    bool pressureFound = false;
    while (!pressureFound) {
      final event = await flutterBarometerEvents.first;
      if (event.pressure != null) {
        setState(() {
          minPress = event.pressure;
        });
        pressureFound = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Barometer Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: MeasureMaxPress,
                child: const Text('Measure max Pressure'),
              ),
              const SizedBox(height: 16),
              maxPress != 0.0
                  ? Text('Max Press: ${maxPress.toStringAsFixed(10)}')
                  : const Text('Max Press: 0'),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: MeasureMinPress,
                    child: const Text('Measure min Pressure'),
                  ),
                  const SizedBox(height: 16),
                  minPress != 0.0
                      ? Text('Min Press: ${minPress.toStringAsFixed(10)}')
                      : const Text('Min Press: 0'),
                  const SizedBox(height: 16),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _calculateHeight,
                    child: const Text('Calculate Building Height'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _compareFCIPress,
                    child: const Text('Compare Min Pressure'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateHeight() {
    print('Max Pressure : ${maxPress.toString()}');
    print('Min Pressure: ${minPress.toString()}');
    final double maxheight =
        ((maxPress * 13600) / 1.27) / 1000; // assume 1hPa = 1m height
    final double minheight =
        ((minPress * 13600) / 1.27) / 1000; // assume 1hPa = 1m height
    double height = maxheight - minheight;
    if (height < 0.0) {
      height = height * -1;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('Building height is $height meters'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _compareFCIPress() {
    String message;

    if (minPress > 1008) {
      message = 'FCI building has lower Pressure';
    } else if (minPress < 1008) {
      message = 'FCI building has higher Pressure';
    } else {
      message = 'Both buildings have the same Pressure';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
