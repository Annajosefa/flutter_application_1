import 'package:flutter/material.dart';

class HarvestRow extends StatefulWidget {
  final double width;
  final String title;
  final bool value;
  const HarvestRow(
      {super.key,
      required this.width,
      required this.title,
      required this.value});

  @override
  State<HarvestRow> createState() => _HarvestRowState();
}

class _HarvestRowState extends State<HarvestRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 220, 182, 238)),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            Container(
              width: widget.width * 0.2,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xfcb205cf)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.value ? 'Yes': 'No',
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
