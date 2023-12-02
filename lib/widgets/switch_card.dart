import 'package:flutter/material.dart';

class SwitchCard extends StatefulWidget {
  final double width;
  final double height;
  final IconData icon;
  final String label;
  final bool? circle;
  final bool value;
  final Function(bool value) onPressed;
  const SwitchCard({
    super.key,
    required this.width,
    required this.height,
    required this.icon,
    required this.label,
    required this.value,
    required this.onPressed,
    this.circle,
  });

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: widget.circle ?? false
            ? ShapeDecoration(
                shape: CircleBorder(),
                color: widget.value ? const Color(0xFFD67BFF) : Colors.white,
              )
            : BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: widget.value ? const Color(0xFFD67BFF) : Colors.white,
              ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.value ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.value ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        widget.onPressed(!widget.value);
      },
    );
  }
}
