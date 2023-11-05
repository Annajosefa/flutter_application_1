import 'package:flutter/material.dart';

import 'package:flutter_application_1/pages/parameter_history_page.dart';

import 'package:flutter_application_1/widgets/parameter_card.dart';

class ParameterPage extends StatefulWidget {
  final double humidity;
  final double light;
  final double soil;
  final double temperature;
  const ParameterPage({
    super.key,
    required this.humidity,
    required this.light,
    required this.soil,
    required this.temperature,
  });

  @override
  State<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends State<ParameterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/home_bg.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            top: 48,
            left: 8,
            child: Column(
              children: [
                ParameterCard(
                  icon: Icons.thermostat,
                  title: 'Temperature',
                  value: widget.temperature,
                  maxValue: 100,
                  label: '°C',
                ),
                ParameterCard(
                  icon: Icons.water_drop,
                  title: 'Humidity',
                  value: widget.humidity,
                  maxValue: 100,
                  label: '%',
                ),
                ParameterCard(
                  icon: Icons.stream,
                  title: 'Soil Moisture',
                  value: widget.soil,
                  maxValue: 100,
                  label: '%',
                ),
                ParameterCard(
                  icon: Icons.light_mode,
                  title: 'Light Level',
                  value: widget.light,
                  maxValue: 100,
                  label: 'lux',
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParameterHistoryPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('See Parameter History'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD67BFF),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
