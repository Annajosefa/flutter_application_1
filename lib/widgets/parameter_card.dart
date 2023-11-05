import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ParameterCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final double value;
  final double maxValue;
  final String label;
  const ParameterCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.label,
  });

  @override
  State<ParameterCard> createState() => _ParameterCardState();
}

class _ParameterCardState extends State<ParameterCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 34,
            lineWidth: 10,
            percent: widget.value / widget.maxValue,
            center: Icon(
              widget.icon,
              size: 26.0,
              color: const Color(0xFFD67BFF),
            ),
            progressColor: const Color.fromRGBO(214, 123, 255, 1),
            reverse: true,
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.value.toStringAsFixed(2)} ${widget.label}',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
