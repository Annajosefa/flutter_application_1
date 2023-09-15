import 'package:flutter/material.dart';

class ParameterCard extends StatefulWidget {
  final double width;
  final String title;
  final Icon icon;
  final double value;
  final int decimal;

  const ParameterCard(
      {super.key,
      required this.width,
      required this.title,
      required this.icon,
      required this.value,
      required this.decimal});

  @override
  State<ParameterCard> createState() => _ParameterCardState();
}

class _ParameterCardState extends State<ParameterCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFD5A4EC)),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
               widget.icon,
              Text(
                widget.title,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.value.toStringAsFixed(widget.decimal),
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 40,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
